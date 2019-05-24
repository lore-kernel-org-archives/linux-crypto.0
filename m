Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8E2C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DA16217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="quENrlOi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389758AbfEXJ1P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:27:15 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:11088 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389724AbfEXJ1P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1558690030;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=hlPSYHMw/eMwCIgNjraTiQbtuzDswJsAmF8hBH/Lhy4=;
        b=quENrlOio7saorwEdINiOpQmzhGsgrI+x/lhpQlQKNzC4Zjah3Oqz5S53U/Wdwr6St
        FzQuFR5+LFgsX74KlugoZ+kFZJQ5fiLWq95F9zhk3PQbGVtgIXyHKmDVKQofjwkDMqJT
        UiL0oanxzVp/78xWqDz2pUh7uZ/BGDRsT/gBoNObGnFh7NgOzk5siDmNWZWOM5CoGoQS
        6j3QluAD5gygBHay0DvEgEWiEW8TPynth2SyE0g7wQWtCHQZiyzY0YRvOjFsd3Ixfroy
        phHIefPumwbiiq9c8QGn2Vian8HxtooeU/SAEF/VTxMyHFStiz4Robt5qEN7WUc8SQdy
        hzdw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbL/Sf94Hg"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv4O9R9TsL
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 24 May 2019 11:27:09 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: another testmgr question
Date:   Fri, 24 May 2019 11:27:09 +0200
Message-ID: <2438452.RXFZfB5nJf@tauon.chronox.de>
In-Reply-To: <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com> <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr> <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 24. Mai 2019, 11:21:30 CEST schrieb Pascal Van Leeuwen:

Hi Pascal,

> I was not aware of that, so thanks for pointing that out.
> Do they use the async calls (_aio) though? Because otherwise they shouldn't
> end up being hardware accelerated anyway ...

Yes, AIO is supported: http://chronox.de//libkcapi/html/ch02s09.html


Ciao
Stephan


