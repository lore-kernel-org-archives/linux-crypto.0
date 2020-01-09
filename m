Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530DCC282DD
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 16:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2684B20721
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 16:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="DFTve4Dq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgAIQiQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 11:38:16 -0500
Received: from linux.microsoft.com ([13.77.154.182]:39062 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgAIQiP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 11:38:15 -0500
Received: from [10.137.112.108] (unknown [131.107.174.108])
        by linux.microsoft.com (Postfix) with ESMTPSA id F2CAF2007684;
        Thu,  9 Jan 2020 08:38:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F2CAF2007684
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1578587895;
        bh=tLUd4VK7GfUjhPceZ2DEioxJk5pIIIxabfHz0xCY7KA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DFTve4DqG+WRFl5jxDn11pDsh+qB2yu/lMwI7WyqHieA5FllIu/xbZkU0MaAkifBc
         NyYW0i2hCHFPcRkMmbopmX8hrd/1BGS0PH44ZSZoF/hTwFh7ybOr3SNGZPDZiJq9u/
         IIwnrGFXQ0vyBXacypwUIPAb26ZY2iUdu+ccNldc=
Subject: Re: [PATCH v1] IMA: fix measuring asymmetric keys Kconfig
To:     Mimi Zohar <zohar@linux.ibm.com>,
        James.Bottomley@HansenPartnership.com, arnd@arndb.de,
        linux-integrity@vger.kernel.org
Cc:     dhowells@redhat.com, sashal@kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20200108160508.5938-1-nramas@linux.microsoft.com>
 <1578545543.5147.32.camel@linux.ibm.com>
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <5411bc3d-74eb-6868-5768-bba3726a661a@linux.microsoft.com>
Date:   Thu, 9 Jan 2020 08:38:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1578545543.5147.32.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/8/20 8:52 PM, Mimi Zohar wrote:

> 
> For the time being, I've pushed out this patch with the existing patch
> description to next-integrity-testing, but the patch description
> should be rewritten clearer.  For example,
> 
> As a result of the asymmetric public keys subtype being defined as a
> tristate, with the existing IMA Makefile, ima_asymmetric_keys.c could
> be built as a kernel module.  To prevent this from happening, this
> patch defines and uses an intermediate Kconfig boolean option named
> IMA_MEASURE_ASYMMETRIC_KEYS.
> 
> Please let me know if you're ok with this wording.
> 
> thanks,
> 
> Mimi
> 

That sounds perfect. Thanks for your help Mimi.

  -lakshmi
