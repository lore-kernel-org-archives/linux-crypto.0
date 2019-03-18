Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0835BC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 19:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE7D20850
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 19:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfCRTKo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:10:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:55700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbfCRTKn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 15:10:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AEA39ACD8;
        Mon, 18 Mar 2019 19:10:42 +0000 (UTC)
Date:   Mon, 18 Mar 2019 20:10:41 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ltp@lists.linux.it
Subject: Re: [LTP] [PATCH v2 0/6] ltp: AF_ALG test helpers and a few
 regression tests
Message-ID: <20190318191041.GB5924@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190318171327.237014-1-ebiggers@kernel.org>
 <20190318182747.GA5924@dell5510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318182747.GA5924@dell5510>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> > Changed since v1:

> >     - Define 'AF_ALG' in include/lapi/socket.h if undefined.
> >       Also move 'SOL_ALG' definition to there.
> The only minor issue is with missing SOL_ALG on older distros.

> Going to push it with this fix including lapi/socket.h on lib/tst_af_alg.c and
> testcases/kernel/crypto/af_alg01.c.

Merged with this small fix.

Kind regards,
Petr
