From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH V4 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Thu, 12 Mar 2015 11:56:45 -0700
Message-ID: <CAL1qeaHq+gDyjBbX-O7dgSfceMNf1nezb2_hMKWvo11RnWt-xA@mail.gmail.com>
References: <1426126012-16061-1-git-send-email-james.hartley@imgtec.com>
	<1426126012-16061-2-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, smueller@chronox.de,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37526 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbCLS4q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 14:56:46 -0400
Received: by qcxr5 with SMTP id r5so21073618qcx.4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2015 11:56:45 -0700 (PDT)
In-Reply-To: <1426126012-16061-2-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On Wed, Mar 11, 2015 at 7:06 PM, James Hartley <james.hartley@imgtec.com> wrote:
> This adds support for the Imagination Technologies hash accelerator which
> provides hardware acceleration for SHA1 SHA224 SHA256 and MD5 hashes.
>
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

One comment below, otherwise this looks fine to me.

> --- /dev/null
> +++ b/drivers/crypto/img-hash.c

> +static int img_hash_hw_init(struct img_hash_dev *hdev)
> +{
> +       unsigned long long nbits;
> +       u32 u, l;
> +       int ret;
> +
> +       ret = clk_prepare_enable(hdev->hash_clk);
> +       if (ret)
> +               return ret;
> +
> +       ret = clk_prepare_enable(hdev->sys_clk);
> +       if (ret) {
> +               clk_disable_unprepare(hdev->hash_clk);
> +               return ret;
> +       }

I think you'll still end up with inflated prepare/enable counts for
these clocks since this function may get called multiple times and the
only clk_disable_unprepare() calls are in the remove() path.  Perhaps
it's best to just enable the clocks in probe() until runtime PM
support is added?

Thanks,
Andrew
