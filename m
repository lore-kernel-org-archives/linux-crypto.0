Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334F4C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04E6E206F9
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="OPlW390B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgCXAXo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:23:44 -0400
Received: from terminus.zytor.com ([198.137.202.136]:36861 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbgCXAXo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:23:44 -0400
Received: from hanvin-mobl2.amr.corp.intel.com (jfdmzpr05-ext.jf.intel.com [134.134.139.74])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 02O0NWue2855582
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 23 Mar 2020 17:23:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 02O0NWue2855582
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020022001; t=1585009415;
        bh=KlNUCvKLtmgUVe/sER4fOO8SCDvsibuLpMPWSHAaMZ8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OPlW390BVJ34hyGgN9xrbDxjr3Lr8UVpnhpLEDvX+tP7mNHNfx4qn8qxfMnI5iwxX
         cZvfHCiTyshO+zIXqEpr8O34WSusbHI5k5/3mhVCN4tMoA2iLBvNrofv1V5yZUAKga
         y6KmHaA4xmM5oXTHCqM/uWX7LyS9WweCwGDix/zTrwJstEXTGP2MJpc+pXLfgKTTbE
         7V4TpbynCpYEHUKTJue/VOPAtqFRC8aGuRVB0zPw0TQA+pgSoXxRZ1Hqe88eS2XnZ4
         yfGlOS9yAWqqIcgVAlOcdhB12oPcR17zSVxHkSAXSStrVNetTePgJ8YWz9IlcdSTMk
         P5aa6akW8RzdQ==
Subject: Re: [PATCH v2 9/9] x86: replace arch macros from compiler with
 CONFIG_X86_{32,64}
To:     Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20200324001358.4520-1-masahiroy@kernel.org>
 <20200324001358.4520-10-masahiroy@kernel.org>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <10b5c2da-38cf-c6ba-bdf5-1064f433c3d6@zytor.com>
Date:   Mon, 23 Mar 2020 17:23:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324001358.4520-10-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-03-23 17:13, Masahiro Yamada wrote:
> If the intention is to check i386/x86_64 excluding UML,
> checking CONFIG_X86_{32,64} is simpler.
> 
> The reason for checking __i386__ / __x86_64__ was perhaps because
> lib/raid6/algos.c is built not only for the kernel but also for
> testing the library code from userspace.
> 
> However, lib/raid6/test/Makefile passes -DCONFIG_X86_{32,64} for
> this case. So, I do not see a reason to not use CONFIG option here.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
