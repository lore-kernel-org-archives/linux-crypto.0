Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20012C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 20:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC07960240
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 20:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbhDMU23 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 16:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343728AbhDMU22 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 16:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A4A66008E;
        Tue, 13 Apr 2021 20:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618345688;
        bh=J1RFqFtZR6AmGTUYUPyMbANMBZs1FFCJbdvDg5+ZIT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXoPWf9wddL09+++wYo8mgSuINs2lPbsFFeRumddr9kIWMLEj1NV5YLA9RWzkV3N1
         yFqxjCQnK0Y9wuwFcN3tPLxSI1W3JdwxJ8cLOfD1ax2d9+7JZSVdnFqToecAYVIpsC
         kBvHsJa/obXWyvic6UyKIRUJSxitFOau084/sSo5Hsl0hKsxdWcLZilEJwJFO2lhcO
         a7vKPfIMr9QpBS0ZjoZrJHpTPUfORqAjxJdBEpzDVzvVO4t9mzileUzOqSCU04TyMw
         0jWOzw9WrYuzS+3Co85DOU68J7ZKWIR41SUrvGA2wDHzhH5WhVHYu7+z+tokiry4BG
         H4DtCSfaU/nhQ==
Date:   Tue, 13 Apr 2021 13:28:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chris von Recklinghausen <crecklin@redhat.com>
Cc:     ardb@kernel.org, simo@redhat.com, rafael@kernel.org,
        decui@microsoft.com, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/1] use crc32 instead of md5 for hibernation e820
 integrity check
Message-ID: <YHX+1/LgNWzAGzsY@sol.localdomain>
References: <20210413161330.20024-1-crecklin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413161330.20024-1-crecklin@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 13, 2021 at 12:13:30PM -0400, Chris von Recklinghausen wrote:
> Suspend fails on a system in fips mode because md5 is used for the e820

Suspend to disk (hibernation), or any suspend?

>  struct restore_data_record {
>  	unsigned long jump_address;
>  	unsigned long jump_address_phys;
>  	unsigned long cr3;
>  	unsigned long magic;
> -	u8 e820_digest[MD5_DIGEST_SIZE];
> +	unsigned long e820_digest;
>  };

This field should probably be renamed to 'e820_crc' or 'e820_checksum', since
"digest" normally means a cryptographic digest.

- Eric
