Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7165C73C7C
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 09:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 985842064B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 09:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGJJly (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 05:41:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:53082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfGJJly (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 05:41:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8CC95AFE2;
        Wed, 10 Jul 2019 09:41:53 +0000 (UTC)
Date:   Wed, 10 Jul 2019 11:41:52 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ltp@lists.linux.it, Michal Such??nek <msuchanek@suse.de>,
        linux-crypto@vger.kernel.org, chetjain@in.ibm.com
Subject: Re: [LTP] [PATCH] crypto/crypto_user02.c: new test that tries to
 delete larval algorithm
Message-ID: <20190710094152.GB30934@rei.lan>
References: <20190709184202.25112-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709184202.25112-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi!
Pushed, thanks.

-- 
Cyril Hrubis
chrubis@suse.cz
