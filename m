Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECF3C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F28E020872
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 04:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbfCYEqO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 00:46:14 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35234 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725294AbfCYEqO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 00:46:14 -0400
Received: from callcc.thunk.org (96-72-84-49-static.hfc.comcastbusiness.net [96.72.84.49] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2P4jokN025582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Mar 2019 00:45:51 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 237AE421A01; Mon, 25 Mar 2019 00:45:50 -0400 (EDT)
Date:   Mon, 25 Mar 2019 00:45:50 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org
Subject: Should we consider removing Streebog from the Linux Kernel?
Message-ID: <20190325044550.GI5675@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Given the precedent that has been established for removing the SPECK
cipher from the kernel, I wonder if we should be removing Streebog on
the same basis, in light of the following work:

	https://who.paris.inria.fr/Leo.Perrin/pi.html
	https://tosc.iacr.org/index.php/ToSC/article/view/7405

Regards,

						- Ted

-----------

From the Cryptography mailing list on metzdowd.com:

From: "perrin.leo@gmail.com" <perrin.leo@gmail.com>
Subject: [Cryptography] New Results on the Russian S-box

Hello everyone,

I have recently sent an e-mail to the CFRG mailing list about my results
on the S-box shared by both of the latest Russian standards in symmetric
crypto and I have been told that it might interest the subscribers of
this mailing list.

In a paper that I am about to present at the Fast Software Encryption
conference, I describe what I claim to be the structure used by the
S-box of the hash function Streebog and the block cipher Kuznyechik.
Their authors never disclosed their design process---and in fact claimed
that it was generated randomly. I established that it is not the case.
More worryingly, the structure they used has a very strong algebraic
structure which, in my opinion, demands a renewed security analysis in
its light. Overall, I would not recommend using these algorithms until
their designers have provided satisfactory explanations about their
S-box choice.

