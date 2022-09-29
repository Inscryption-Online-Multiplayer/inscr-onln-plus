extends SigilEffect

# This is called whenever something happens that might trigger a sigil, with 'event' representing what happened
func handle_event(event: String, params: Array):

	# attached_card_summoned represents the card bearing the sigil being summoned
	if event == "card_summoned" and params[0] == card and isFriendly:

		# Die on summon if no gems
		if not "Perish" in card.get_node("AnimationPlayer").current_animation:

			var kill = not (slotManager.get_friendly_cards_sigil("Great Mox"))

			for moxcol in ["Green", "Blue", "Orange"]:
				for foundMox in slotManager.get_friendly_cards_sigil(moxcol + " Mox"):
					if foundMox != self:
						kill = false;
						break
			
			if kill:
				print("Gem dependant card should die!")
				card.get_node("AnimationPlayer").play("Perish")
				slotManager.rpc_id(fightManager.opponent, "remote_card_anim", card.slot_idx(), "Perish")
		