Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25DAC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 09:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8955721872
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 09:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfCOJik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:38:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:55564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726886AbfCOJik (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 05:38:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9E480AE17;
        Fri, 15 Mar 2019 09:38:39 +0000 (UTC)
Date:   Fri, 15 Mar 2019 10:38:38 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH 1/6] lib: add tst_af_alg lib
Message-ID: <20190315093838.GB4990@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190221053026.18489-1-ebiggers@kernel.org>
 <20190221053026.18489-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221053026.18489-2-ebiggers@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> From: Eric Biggers <ebiggers@google.com>

> Add helper functions for creating and using AF_ALG sockets.  AF_ALG is
> the userspace interface to algorithms in the Linux kernel's crypto API.
> See https://www.kernel.org/doc/html/latest/crypto/userspace-if.html for
> more information about this interface.

AF_ALG is not defined in old distros [1]:
/usr/src/ltp/lib/tst_af_alg.c: In function 'tst_alg_create':
/usr/src/ltp/lib/tst_af_alg.c:15: error: 'AF_ALG' undeclared (first use in this function)

We should add it (not sure whether to new lapi/if_alg.h or to lapi/socket.h).

Kind regards,
Petr

[1] https://api.travis-ci.org/v3/job/506663263/log.txt
