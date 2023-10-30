Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12B5C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 09:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjJ3JZY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjJ3JZX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 05:25:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B76B6
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:25:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5409bc907edso6467524a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698657916; x=1699262716; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmFLuyKlECEojTd5uNeXRq45Fl+59lueEyhJDtZD3QM=;
        b=JbNmgyTx1F6isFm7aQH5V0IPVY4T5yhsnTO2Pv6Ar0S2csiO1LkgS6h8CjpKXPBHg4
         Nvy7OeZZkAhA4KXj3xGTuNt59bg/mjUz36xkKFL7BX1ohj1ORJk6cvfPvdTu/NKGuVxI
         s6QazRJCtpDd+iTeUlWwK4S/MxZLIcZDzc7ahbkH1bSrmbiy8JC81Thl/eHeL1uFlmRg
         CK8vlQUz5ZY1Z313ipADbM2MOMeBJ2I1SfCZWoPrVMF9b1Wu+DRb24BQpGfmOPiHBzmw
         XU0zwZ2rGmShSO9yXmMrgMjr6D3q6QcVTuHT13OJOb7hvPaMqBZ4EhUf7IjbLxsavbfo
         GTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698657916; x=1699262716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmFLuyKlECEojTd5uNeXRq45Fl+59lueEyhJDtZD3QM=;
        b=xPuU5fU9i6xzq8UAs18jN/g+JkHqUFFxdmRYKvPXOA2KvgPNOX5rLanNKvtUFyUMk0
         2ujjYr50C1bwHPwrX0LYDh9p4+G+ge/tkM4qr0Nqe6XOAbeRtUlF5qzjmeBSgBVu3n5u
         6+M2rjsGcfAFDyrAnnYf1S4OHvanZayXd+R/5vKUoWkcE6RRI8yrgs9siC3kTWdU0soM
         7hY+TCpGvXXFNAgIJbyjs/a0E2WOcZsu5l1eKPkfOOzQV8jhhUoUOOcYl6Akekr5T66z
         G5XgOrxpSwSrzYbBqKja1L6eXkMH5yuiZQGHO+4mt/zDkNy44teN74nXtp+8u8bSca2w
         wHug==
X-Gm-Message-State: AOJu0YxhGwCd6uO4r0jPlfC+ZERkM8sWOzgW6wN7+4pXH6yud/94d+lk
        WgqlZHCFUXRApQKlLNnhT89QjA==
X-Google-Smtp-Source: AGHT+IGMYchESDDsJp2sYMiS15sYjzf8QJe5m//0XH7TxOz8/MZF1ZI5LzAugfMAqInKVyb0sYLBzg==
X-Received: by 2002:a17:907:d043:b0:9d4:771b:69b4 with SMTP id vb3-20020a170907d04300b009d4771b69b4mr849497ejc.44.1698657916594;
        Mon, 30 Oct 2023 02:25:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q7-20020a05600c46c700b004076f522058sm12307096wmo.0.2023.10.30.02.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 02:25:16 -0700 (PDT)
Date:   Mon, 30 Oct 2023 12:25:13 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     tianjia.zhang@linux.alibaba.com
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [bug report] lib/mpi: Extend the MPI library
Message-ID: <9efa9c91-52a7-4535-b0ff-d3e501316e48@kadam.mountain>
References: <da288365-f972-479d-91bf-ceef411abdb9@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da288365-f972-479d-91bf-ceef411abdb9@moroto.mountain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 30, 2023 at 12:03:38PM +0300, Dan Carpenter wrote:
> Hello Tianjia Zhang,
> 
> The patch a8ea8bdd9df9: "lib/mpi: Extend the MPI library" from Sep
> 21, 2020 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	lib/crypto/mpi/mpi-div.c:46 mpi_fdiv_q()
> 	error: potential null dereference 'tmp'.  (mpi_alloc returns null)
> 
> lib/crypto/mpi/mpi-div.c
>     43 void mpi_fdiv_q(MPI quot, MPI dividend, MPI divisor)
>     44 {
>     45         MPI tmp = mpi_alloc(mpi_get_nlimbs(quot));
>                    ^^^^^^^^^^^^^^^
> Check for failure?

By the way, in the other thread we discuessed if added a NULL check was
required when the code basically "works fine" as is.  In this case the
allocation is larger and must be checked.

regards,
dan carpenter


> 
> --> 46         mpi_fdiv_qr(quot, tmp, dividend, divisor);
>     47         mpi_free(tmp);
>     48 }
> 
> regards,
> dan carpenter
