From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2] crypto: Remove duplicate code of SG helpers functions
Date: Fri, 18 Sep 2015 14:57:08 +0200
Message-ID: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37098 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbbIRM53 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 08:57:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

This patch series try to remove some duplicate code of some SG helpers functions.
The first four patch replace custom functions by already in-tree helper functions.

The fourth add a new functions "sg_nents_len_chained" who is the same as
sg_nents_for_len with an additionnal arguments.

The last three patch use sg_nents_len_chained for removing custom functions.

Note that I do not own any of those hardware to test.

Regards
