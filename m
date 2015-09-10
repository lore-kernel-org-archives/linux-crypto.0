From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: crypto: Remove duplicate code of SG helpers functions
Date: Thu, 10 Sep 2015 15:21:35 +0200
Message-ID: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36663 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbIJNVr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 09:21:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello

This patch series try to remove some duplicate code of some SG helpers functions.
The first three patch replace custom functions by already in-tree helper functions.

The fourth add a new functions "sg_nents_for_len2" who is the same as
sg_nents_for_len with an additionnal arguments.
Note that I do not like the name, but I do not find any good name.

The last three patch use sg_nents_for_len2 for removing custom functions.

I send those patch as RFC since I do not own any of those hardware to test.

Regards
