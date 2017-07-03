From: Simon =?utf-8?Q?Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: Re: [PATCH 00/10] Fix alignment issues in staging/ccree
Date: Mon, 3 Jul 2017 14:28:28 +0200
Message-ID: <20170703122826.wslnsnhtzk4cczsj@epsilon.nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
 <CAOtvUMdp+xTAhW1Xd1o0Ch4GjzXgLPHYhyefB9T1p6xjTFVRQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33435 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdGCM2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 08:28:33 -0400
Received: by mail-lf0-f53.google.com with SMTP id z78so60222244lff.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2017 05:28:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOtvUMdp+xTAhW1Xd1o0Ch4GjzXgLPHYhyefB9T1p6xjTFVRQQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 03, 2017 at 10:19:31AM +0300, Gilad Ben-Yossef wrote:
> but for the few cases where its a complex expression that can be
> broken down like this one:
> 
> WARNING: line over 80 characters
> #93: FILE: drivers/staging/ccree/ssi_buffer_mgr.c:437:
> +     (AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
> 
> It would be great if you fix those.

Do you mean to fix them by just breaking the line after the ternary
operator? Is that OK according to the code style rules?

If not, then the two warnings in ssi_aead_handle_config_buf can be
fixed by simply having a local variable:

const unsigned int buflen = AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size;

but I'm not sure if the same can be done in
ssi_buffer_mgr_map_hash_request_update for (update_data_len - *curr_buf_cnt)
as it's not always the case that update_data_len is greater than
*curr_buf_cnt. Even if it's safe to always calculate it I'm not
entierly sure what to call the variable.

Other then those two functions I don't think that there are any more
lines that can be fixed without renaming functions / variables or
by rewriting them to decrease the indentation depth, as you wrote.

-- Simon
