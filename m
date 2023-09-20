Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76808C05022
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 20:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjITUtW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjITUtV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 16:49:21 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8082B9
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:49:15 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-5033918c09eso472097e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695242954; x=1695847754; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6FhIbvn7MsGlLObvmOiWL/jIm9VZXSDgz2MjQZTKc18=;
        b=T24J5cD7Mkice2Xyf+OMoqOHdGKfX+kda3LRAb9LTtDbVEWjR+aUnQlSldamJcVaui
         +V6drE184SL0ph4PvRyFnn8wQN9BOacJkcljKS+2qYDJAh3Uf2lMTvr1VvSeWdq053S2
         RPH+oyDJb59UBnmlNjyMMmsyyzP+nF+hPNyvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695242954; x=1695847754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6FhIbvn7MsGlLObvmOiWL/jIm9VZXSDgz2MjQZTKc18=;
        b=CZMKKQU3XPihu+sAkAz2I/dIMaGhwvnmekqhlT/yGQ39kY1LXzrGIGPBKbG5YT9n3V
         jWx8kmanq+qToAJd0EGkFn/qAH5jlDtdEBep20pKx70+d+beTEoKIE8fMxqziQoqfCsI
         Iwtwcac+0wb+8kkoNvF3neZ374fMLNSHbJe9Q6Cokla+tSr6syevXtxFWcK2zFZM/OWG
         bCIawBRCAMP1aglz6boYaAet0i3NlET8sLVjXfm+ospyM+ih80cWWNvK2J9euJkh/vT+
         DuO15ji0UihlFJawYsAeP8Xk5vdyly3eICBPzdVK/OzWMqZGvVxATdjtHwaQ1ljZgXoW
         9csA==
X-Gm-Message-State: AOJu0YwP7OkhFkWpbrxrXf8ywB+xcqnFfinDP5KHTV1R4N6uWJWVabEL
        vQ7J97midGUJuFAp1/AwuKy+5sMMMNTvPMIeXXcq/gXb
X-Google-Smtp-Source: AGHT+IHj4VRJ9+6eBEGnYa7nSnavM0ILDtDmitBYpFOe3c1UnEiIBOuA5ZgajDzE23whmRvefbZbHQ==
X-Received: by 2002:a2e:9dd1:0:b0:2bc:c3ad:f41b with SMTP id x17-20020a2e9dd1000000b002bcc3adf41bmr3354238ljj.2.1695242953707;
        Wed, 20 Sep 2023 13:49:13 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090606cf00b0099275c59bc9sm9836202ejb.33.2023.09.20.13.49.12
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 13:49:13 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5315b70c50dso172063a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:49:12 -0700 (PDT)
X-Received: by 2002:a05:6402:1505:b0:525:69ec:e1c8 with SMTP id
 f5-20020a056402150500b0052569ece1c8mr2859302edw.40.1695242952648; Wed, 20 Sep
 2023 13:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230920060615.GA2739@sol.localdomain> <CAHk-=wja26UmHQCu48n_HN5t5w3fa6ocm5d_VrJe6-RhCU_x9A@mail.gmail.com>
 <20230920193203.GA914@sol.localdomain> <CAHk-=wicaC9BhbgufM_Ym6bkjrRcB7ZXSK00fYEmiAcFmwN3Kg@mail.gmail.com>
 <20230920202126.GC914@sol.localdomain> <CAHk-=wgu4a=ckih8+JgfwYPZcp-uvc1Nh2LTGBSzSVKMYRk+-w@mail.gmail.com>
 <20230920204524.GD914@sol.localdomain>
In-Reply-To: <20230920204524.GD914@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 20 Sep 2023 13:48:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjx__9L2Ej0DBWGgyjxEKkdKJW=zDvjEhLTBsBgd8MdOA@mail.gmail.com>
Message-ID: <CAHk-=wjx__9L2Ej0DBWGgyjxEKkdKJW=zDvjEhLTBsBgd8MdOA@mail.gmail.com>
Subject: Re: [RFC] Should writes to /dev/urandom immediately affect reads?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Sept 2023 at 13:45, Eric Biggers <ebiggers@kernel.org> wrote:
>
> See my first email where I explained the problems with the current behavior.
> Especially the third paragraph.

I really don't think that's the obvious way at all. Anybody who treats
a seed file that way just doesn't care, and whipped up a (bad) shell
script randomly.

Whatever.

             Linus
