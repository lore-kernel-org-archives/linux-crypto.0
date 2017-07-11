From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 00/10] Fix alignment issues in staging/ccree
Date: Tue, 11 Jul 2017 14:35:54 +0300
Message-ID: <CAOtvUMdL=brohVZR3b0148Owe9kfdwWNaY8JVsdAqm75N3gFzQ@mail.gmail.com>
References: <20170701232555.5538-1-simon@nikanor.nu> <CAOtvUMdp+xTAhW1Xd1o0Ch4GjzXgLPHYhyefB9T1p6xjTFVRQQ@mail.gmail.com>
 <20170703122826.wslnsnhtzk4cczsj@epsilon.nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: =?UTF-8?Q?Simon_Sandstr=C3=B6m?= <simon@nikanor.nu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:33191 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdGKLf4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 07:35:56 -0400
Received: by mail-yb0-f178.google.com with SMTP id 84so36998883ybe.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 04:35:55 -0700 (PDT)
In-Reply-To: <20170703122826.wslnsnhtzk4cczsj@epsilon.nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 3, 2017 at 3:28 PM, Simon Sandstr=C3=B6m <simon@nikanor.nu> wro=
te:
> On Mon, Jul 03, 2017 at 10:19:31AM +0300, Gilad Ben-Yossef wrote:
>> but for the few cases where its a complex expression that can be
>> broken down like this one:
>>
>> WARNING: line over 80 characters
>> #93: FILE: drivers/staging/ccree/ssi_buffer_mgr.c:437:
>> +     (AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size),
>>
>> It would be great if you fix those.
>
> Do you mean to fix them by just breaking the line after the ternary
> operator? Is that OK according to the code style rules?

Yes, it is.

>
> If not, then the two warnings in ssi_aead_handle_config_buf can be
> fixed by simply having a local variable:
>
> const unsigned int buflen =3D AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size;
>
> but I'm not sure if the same can be done in
> ssi_buffer_mgr_map_hash_request_update for (update_data_len - *curr_buf_c=
nt)
> as it's not always the case that update_data_len is greater than
> *curr_buf_cnt. Even if it's safe to always calculate it I'm not
> entierly sure what to call the variable.

No need not. I simply meant to break this:

 (update_data_len - *curr_buf_cnt)

To this:

 (update_data_len -
   *curr_buf_cnt)

Assuming it made sense.

> Other then those two functions I don't think that there are any more
> lines that can be fixed without renaming functions / variables or
> by rewriting them to decrease the indentation depth, as you wrote.

No, not in this patch.

Thanks!
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
