From: Marcus Meissner <meissner@suse.de>
Subject: tcrypt failing on hmac(crc32)
Date: Wed, 25 May 2016 09:07:52 +0200
Message-ID: <20160525070752.GB6559@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbcEYHHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 03:07:55 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3D76FAC77
	for <linux-crypto@vger.kernel.org>; Wed, 25 May 2016 07:07:53 +0000 (UTC)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

when enabling the testmgr framework and FIPS in 4.6 and 4.4 and running "modprobe tcrypt"

[ 1153.298266] alg: hash: Failed to load transform for hmac(crc32): -2
[ 1153.340636] tcrypt: one or more tests failed!

I spent some hours making sense of what is missing, but I got lost in the maze
of the crypto apis between sync and async hashes somewhere.

Does anyone know the solution for this, otherwise I will need to continue looking.

Ciao, Marcus
