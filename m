Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92774C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 00:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbiA1AMg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 19:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbiA1AMf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 19:12:35 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEBDC061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 16:12:34 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id h7so10205739ejf.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 16:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cx7Q9eYiTF57W8EvjtytODkNVtL1gqHvnxpZCbsRo/E=;
        b=a3DP7yQoXkUURS6GcKXcBP835/cVQsxN9ExsdjiBw2awOc0P0i/2dbBrpMiKqyLZzd
         56MuRaThF/VBxNbcKQhNxm+QPO9jVTG6jUpCuu1G+nDz5plwdtd1+T2FtNzpVfHFgu5j
         yKzka7bNMU2w6Wzi+Y3C1BRB+w0V7ia5r9QArzY3Ay7WIj3FFdsOSCyjd6oLuNZw+/JM
         5+s3LSyWthhvPIGxTfTOr39HI3kkAVi3X8KVXQhxw8qDjaI1Rle50c6kT3h3pKnh+7P9
         NITsI5w5ZoXxahUNkvJkDkyuUTth13Z1l17brzUz5z1cguYE4Y6AjfQGkrAKaokGwmdY
         WyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cx7Q9eYiTF57W8EvjtytODkNVtL1gqHvnxpZCbsRo/E=;
        b=DPpaJ1UYB3Fd6gTxzgSRyPA3Xvv7KyPG9V03LUo8SlXnq22pGJzB39Mbv0BES+WZqh
         0ElsbZYwZwJ0BgpYltd/R0OvSPDAwpFhDv32fK7cjyc39bq0Gc/ltlFiDq5FC0hWJuj8
         QUzl7/DQ/pFtWG7ElXclLbk9Q5+n9Umn3ZDbXWF92lZzip2/PZD2fPk7XlrYQL2YORe7
         lX9FptcN8at3lzATUJG0IQMdWJklqPPHqEkjLnuqByc2IENKBf8j1ilYjWqvEHMVazTN
         NPTXqAsPu+JIqO1u+qpTU4HFCLOSu5u8tWIY5hIKhmTBH/AF8bfNGnx52knRb9/ON5tN
         8qcg==
X-Gm-Message-State: AOAM53057t+nv7fRcMk9yF/ucyptcIeIsHsPX9AT7ZcOWjltG9cdeJdn
        aZkFz7VcNS0imu68e/ijdEUSgo/Uy6wZMmYZByQ=
X-Google-Smtp-Source: ABdhPJyIK7Pad7vQ8XBGqhr7eFgtIgiSsZOhdE+YXHeTCrDmciVWKWXg3P1/lU66ZpoSdKwvjfStoKO1bLtX5fEo4oU=
X-Received: by 2002:a17:906:99c6:: with SMTP id s6mr5137993ejn.522.1643328753238;
 Thu, 27 Jan 2022 16:12:33 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmkhWDwJ2AwpBFnyYrM-YXDgBfFyCeJsmMux3gM8G+Gveg@mail.gmail.com>
 <YfLtrrB+140KkiN0@sol.localdomain>
In-Reply-To: <YfLtrrB+140KkiN0@sol.localdomain>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 28 Jan 2022 08:12:20 +0800
Message-ID: <CACXcFmkTiiS3M5B6RtyG=oD9+CqncFR6kQX1SZHvVNshVe=vKQ@mail.gmail.com>
Subject: Re: RFC random(4) We don't need no steenking ...
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Denker <jsd@av8n.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:

> On Thu, Jan 27, 2022 at 05:04:07PM +0800, Sandy Harris wrote:
> > Current code in extract_buf() declares a local struct blake2s_state,
> > calls blake2s_init() which uses initialisation constants
>
> Which is good, because BLAKE2s is defined to use certain constants.  If
> different constants were used, then it wouldn't be BLAKE2s anymore, but rather
> some homebrew crypto with unknown security properties (like the old "SHA-1" that
> wasn't really SHA-1).

That's a reasonable argument & something very similar applies to
chacha usage. I do not think it holds water, though, since we
would still use the blake & chacha transforms. Even in blake,
every iteration except the first applies the transform to
arbitrary somewhat random data.

> > and moves data into the chacha state with memcpy().
>
> It's actually XOR'd in.  Please take a closer look at crng_reseed().

You are correct.
