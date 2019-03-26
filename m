Return-Path: <SRS0=ouVC=R5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8130CC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 16:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 577852070D
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 16:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfCZQPV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:15:21 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:50708 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfCZQPV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Mar 2019 12:15:21 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id A6D5772CCAC
        for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2019 19:15:19 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 7749A4A4AE9
        for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2019 19:15:19 +0300 (MSK)
Date:   Tue, 26 Mar 2019 19:15:19 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8 04/10] KEYS: do not kmemdup digest in
 {public,tpm}_key_verify_signature
Message-ID: <20190326161519.ptp7z2xa7r6tvn56@altlinux.org>
Mail-Followup-To: linux-crypto@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190326125842.24110-5-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190326125842.24110-5-vt@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 26, 2019 at 03:58:36PM +0300, Vitaly Chikunov wrote:
> Treat (struct public_key_signature)'s digest same as its signature (s).
> Since digest should be already in the kmalloc'd memory do not kmemdup
> digest value before calling {public,tpm}_key_verify_signature.
> 
> Patch is split from the previous as suggested by Herbert Xu.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: keyrings@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>

For Patchwork auto-tagging, based on Message-ID: <ed78154e-2491-8e3e-3362-e45df4fda011@gmail.com>

Reviewed-by: Denis Kenzior <denkenz@gmail.com>

On Tue, Mar 26, 2019 at 11:00:40AM -0500, Denis Kenzior wrote:
> Feel free to add
> Reviewed-by: Denis Kenzior <denkenz@gmail.com>
> 
> to this and patch 4.
> 
> Regards,
> -Denis

Thanks!
