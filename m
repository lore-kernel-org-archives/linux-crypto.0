Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C52C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 08:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCKIP6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 03:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCKIP5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 03:15:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54F31408AB
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50150609EB
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD17CC4339C
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678522555;
        bh=heACOvW/tQ54SR2BQMCs+Qx8O3CY9YeQ/yHzY7pfe1E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IKy88oufT9pMd68uRH8losSbMf6m/+RV7uBx/J+youlQeN4jXdFPpNXU/uaf2HFD9
         oREcSZcuwG41D6d9C7NW57gzE3YZ+aAJ+3SwltuzKH+xkTiNfAM4RxSfVCbt9VNZDg
         QOg62lfA25lympv1DCX5AtPRLWSH95nCLU5/HWybpLl90b2DYoqSOmHaCj817QuGl/
         w2FVgqSLLAdqR3jJ9uOSSKNDuJrWbhQsPa0FhhPmUCZfW70NnODkOBNDhTUrRx4Kf6
         7qAkJheUMBVe9kkCQ7NHNx53CCcs3HFEQLOEk1OYoYUa9hk4GatQAvujSVhFC47T1H
         UmFuMYbHOdACw==
Received: by mail-lf1-f47.google.com with SMTP id i9so9609769lfc.6
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:15:55 -0800 (PST)
X-Gm-Message-State: AO0yUKXRvTrDhLLZ32eYQ89kiHR5YAeD1Z/h/PpopnCSyhgni/HcD2/J
        s7iN1Gzdl615t8k/2r91fkWKn8Eaz/7PnG3wOAk=
X-Google-Smtp-Source: AK7set+voSp/QuAjrPBAGahXG+0GQ2YkWm5LF1C9S2N6lnCVRdND58gDRlUJ3ypWoWabRsDXniFLa6xotfQcqzp+6As=
X-Received: by 2002:ac2:5de1:0:b0:4dd:af74:fe17 with SMTP id
 z1-20020ac25de1000000b004ddaf74fe17mr8745499lfq.7.1678522553673; Sat, 11 Mar
 2023 00:15:53 -0800 (PST)
MIME-Version: 1.0
References: <20230217144348.1537615-1-ardb@kernel.org> <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
 <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
 <ZAsDT00Jgs2p6luL@gondor.apana.org.au> <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
 <ZAw2eHDQELdiVXcZ@gondor.apana.org.au>
In-Reply-To: <ZAw2eHDQELdiVXcZ@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 11 Mar 2023 09:15:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
Message-ID: <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Mar 2023 at 09:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Mar 10, 2023 at 05:18:05PM +0100, Ard Biesheuvel wrote:
> >
> > Does that mean you are bringing back blkcipher? I think that would the
> > right thing to do tbh, although it might make sense to enhance
> > skcipher (and aead) to support this.
>
> I haven't gone into that kind of detail yet but my first impression
> is that it would be the analogue of shash and skcipher would simply
> wrap around it just like ahash wraps around shash.
>
> > Could we perhaps update struct skcipher_request so it can describe
> > virtually mapped address ranges, but permit this only for synchronous
> > implementations? Then, we could update the skcipher walker code to
> > produce a single walk step covering the entire range, and just use the
> > provided virtual addresses directly, rather than going through a
> > mapping interface?
>
> Since skcipher doesn't actually need to carry any state with it
> I'd like to avoid having an skcipher_request at all.

Doesn't that depend on the implementation? It might have a >0 size
request context size, no? Or do we just allocate that on the stack?
