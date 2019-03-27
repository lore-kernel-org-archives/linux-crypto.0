Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CABC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 14:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA8C22087C
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 14:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553695637;
	bh=Mku8kBfu/XTRmQdXEuo27a1DJOJi7DhxWyvgEUgIv0Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:List-ID:From;
	b=KMUk4VQzriSf681Qf20MFY9i/fan33GBDVchTTBSMMwQVtcoTuY7sdFPtrmZfxRoZ
	 7CU8JJidmU/304yliDuZIjWz9fLtr2D9siy6FIDWUnzt2t7TuS3+8Og3iLeDPQY37m
	 +sG5g1U9UyIqObJma4B7MqUQjRtm86B/2W9OSfN4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbfC0OHL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfC0OHK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 10:07:10 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB0882087C;
        Wed, 27 Mar 2019 14:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553695630;
        bh=Mku8kBfu/XTRmQdXEuo27a1DJOJi7DhxWyvgEUgIv0Q=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=QW6Q5oUDOOevlIOD0S8PHL8XWosWu90ptboO/PkEtbwFc44fa2s3fus5FQlVDT/1S
         aRpiJBiZrgWD/tUZuS87Hl6zAj9FMrh+9KU9VUJLcoEgWyh+0FOGwNJUhVFdJynAva
         eZA3CN6gRy3AG8WEsnzxDlzsgxe0Dm1RM1gOCahM=
Date:   Wed, 27 Mar 2019 15:07:06 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Andrej Shadura <andrew.shadura@collabora.co.uk>
cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        kernel@collabora.com, Theodore Ts'o <tytso@mit.edu>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] HID: add driver for U2F Zero built-in LED and RNG
In-Reply-To: <02f265dd-5ccd-7c42-2bde-b7c5e354cd69@collabora.co.uk>
Message-ID: <nycvar.YFH.7.76.1903271506140.19912@cbobk.fhfr.pm>
References: <20190309183213.7598-1-andrew.shadura@collabora.co.uk> <nycvar.YFH.7.76.1903181542260.19912@cbobk.fhfr.pm> <02f265dd-5ccd-7c42-2bde-b7c5e354cd69@collabora.co.uk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 18 Mar 2019, Andrej Shadura wrote:

> > 
> > This driver isn't really a generic (transport-agnostic) one (which also 
> > means it's missing USB dependency in Kconfig btw).
> 
> Thanks, I forgot that one.
> 
> > Is there a reason why it can't be abstracted that way so that it'd fit our 
> > principal model in HID subsystem?
> 
> I tried and I failed. The HID subsystem doesn’t provide the 
> functionality necessary to implement the protocol, or maybe I’m missing 
> something, but I haven’t found a way.

After reading through the driver, I tend to agree that this is the least 
painful way, so it's probably worth violating our usual mode of operation 
a bit :)

So could you please resend with the proper USB dependency added?

Thanks,

-- 
Jiri Kosina
SUSE Labs

