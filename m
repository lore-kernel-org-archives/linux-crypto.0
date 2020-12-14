Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3200AC2BB48
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D89C822473
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503472AbgLNUmF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503465AbgLNUmA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:42:00 -0500
Date:   Mon, 14 Dec 2020 12:41:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607978479;
        bh=bZ5V7cOF7Y3xEFjRNlJqO2zCRUqXweheRPkf/g8LBCE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/SHUzEA9Fb7pfRUiNH3yy5W3V2/z/6ZJ41cbKshqUZC7G7kjPc0LeyPXmKO1kGfQ
         B5/WkyrjNdgEBTpCSLTNsldwIkF57ta9xS2jV6GJls1roMtGCM7JIkhnOre+W7/U+X
         y4y2LYeQSWM8l8FKZTarm2+1jEdRBeL2iEmHxyEADkq27oiXc4uovchXd5TWWXmScs
         QtFRIJipqi7+HIL5z4zG91R3kPvU1M04YeVqg5nQ/kCOI7SRRoO+sjLwFys/Jxwozc
         eKVdosF3I8Q2WrqpGhKhCQKDHc0+z78WvVts/XyYxgX7qf63IJhT9+wFNVEdfeIBP1
         5m4zUr/fqa+1Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, TimGuo-oc@zhaoxin.com,
        CooperYan@zhaoxin.com, QiyuanWang@zhaoxin.com,
        HerryYang@zhaoxin.com, CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Message-ID: <X9fN7mOMdn1Dxn63@sol.localdomain>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <X9Ov3RWDpUik7gXo@sol.localdomain>
 <1f8d17bf-c1d9-6496-d2f8-5773633011fb@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f8d17bf-c1d9-6496-d2f8-5773633011fb@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 14, 2020 at 10:28:19AM +0800, Tony W Wang-oc wrote:
> On 12/12/2020 01:43, Eric Biggers wrote:
> > On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
> >> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> >> On platforms with Zhaoxin CPUs supporting this X86 feature, When
> >> crc32c-intel and crc32c-generic are both registered, system will
> >> use crc32c-intel because its .cra_priority is greater than
> >> crc32c-generic. This case expect to use crc32c-generic driver for
> >> some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
> >> CPUs support from crc32c-intel.
> >>
> >> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> > 
> > Does this mean that the performance of the crc32c instruction on those CPUs is
> > actually slower than a regular C implementation?  That's very weird.
> > 
> 
> From the lmbench3 Create and Delete file test on those chips, I think yes.
> 

Did you try measuring the performance of the hashing itself, and not some
higher-level filesystem operations?

- Eric
