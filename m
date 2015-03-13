From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH V5 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Thu, 12 Mar 2015 17:28:31 -0700
Message-ID: <CAL1qeaGyJzLXpuOsVRoBqjW3DcTF7VX2Gge3c+3DfPnyKB5_pQ@mail.gmail.com>
References: <1426202247-6221-1-git-send-email-james.hartley@imgtec.com>
	<1426202247-6221-2-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, smueller@chronox.de,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41635 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbCMA2c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 20:28:32 -0400
Received: by qcrw7 with SMTP id w7so22989933qcr.8
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2015 17:28:31 -0700 (PDT)
In-Reply-To: <1426202247-6221-2-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On Thu, Mar 12, 2015 at 4:17 PM, James Hartley <james.hartley@imgtec.com> wrote:
> This adds support for the Imagination Technologies hash accelerator which
> provides hardware acceleration for SHA1 SHA224 SHA256 and MD5 hashes.
>
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

Looks good to me.

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
