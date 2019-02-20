Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203B2C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 11:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F34962086C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 11:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfBTLJL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:09:11 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:41978 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbfBTLJL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 06:09:11 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gwPkT-0006qk-Dj; Wed, 20 Feb 2019 19:09:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gwPkS-0002KX-1T; Wed, 20 Feb 2019 19:09:08 +0800
Date:   Wed, 20 Feb 2019 19:09:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zain Wang <wzz@rock-chips.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [bugzilla-daemon@bugzilla.kernel.org: [Bug 202405] Corrupted data
 when writing to dm-crypt device]
Message-ID: <20190220110907.j6vmgc7yt2zpyvzs@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="m2hoieql7ntvhrnx"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--m2hoieql7ntvhrnx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Please take a look at this bug report.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--m2hoieql7ntvhrnx
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <bugzilla-daemon@bugzilla.kernel.org>
Envelope-to: herbert@localhost
Delivery-date: Wed, 20 Feb 2019 18:57:13 +0800
Received: from localhost ([::1] helo=gondobar.mordor.me.apana.org.au)
	by gondobar with esmtp (Exim 4.89)
	(envelope-from <bugzilla-daemon@bugzilla.kernel.org>)
	id 1gwPYv-0002Ig-ET
	for herbert@localhost; Wed, 20 Feb 2019 18:57:13 +0800
Received: from deadmen.mordor.me.apana.org.au [192.168.137.2]
	by gondobar.mordor.me.apana.org.au with IMAP (fetchmail-6.3.26)
	for <herbert@localhost> (single-drop); Wed, 20 Feb 2019 18:57:13 +0800 (CST)
Received: from mail.wl.linuxfoundation.org ([198.145.29.98])
	by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
	id 1gwPYB-0006Pb-Qy
	for <herbert@gondor.apana.org.au>; Wed, 20 Feb 2019 18:56:28 +0800
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
	by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9E50828E3F
	for <herbert@gondor.apana.org.au>; Wed, 20 Feb 2019 10:56:23 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
	id 90F192E019; Wed, 20 Feb 2019 10:56:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
	pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
	NO_RELAYS autolearn=unavailable version=3.3.1
From: bugzilla-daemon@bugzilla.kernel.org
To: herbert@gondor.apana.org.au
Subject: [Bug 202405] Corrupted data when writing to dm-crypt device
Date: Wed, 20 Feb 2019 10:56:23 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Platform Specific/Hardware
X-Bugzilla-Component: ARM
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lirik.lv@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-arm-kernel@lists.arm.linux.org.uk
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202405-2647-24Qi9cuktm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202405-2647@https.bugzilla.kernel.org/>
References: <bug-202405-2647@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP

https://bugzilla.kernel.org/show_bug.cgi?id=3D202405

--- Comment #8 from lirik.lv@gmail.com ---
(In reply to Herbert Xu from comment #7)
> Since you appear to be using rk_crypto could you please try disabling that
> (e.g., by not loading it if it's a module or use crconf to lower its
> priority) and see if the problem persists?
>=20
> Thanks!

Yes!
I've disabled `CONFIG_CRYPTO_DEV_ROCKCHIP` and problem is gone.

Thank you!

--=20
You are receiving this mail because:
You are on the CC list for the bug.=

--m2hoieql7ntvhrnx--
