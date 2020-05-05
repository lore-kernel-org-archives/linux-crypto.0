Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581FDC47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 21:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2299620735
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 21:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gchBw5gG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgEEVkD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 17:40:03 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:53871 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgEEVkD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 17:40:03 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c7ed667d;
        Tue, 5 May 2020 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=awCQfknLvS6+NKExu3LCs750TJ8=; b=gchBw5
        gGUFeRzJH2nKUGxjRWnNGqyTFTDlw0JJQ7PQ10IR0BxggAAQSs1dzcotb8RmNcu9
        05LhOmQ1FOQGcZM9qIgmGIM9XZv3XIuvAvXwddyf6opsnem9YkTWa8t/ZquydjdR
        TAi/kotPDWA0DoV2WuSjKK1tlciWtg51B5D7sGPyDHQA+oEIA7poRRTheJ+MqOFK
        nmD7Zexn07xEA9XakUesVYaRyrH3QaIIE+eV6GATfF6vwPYc+TcbqoBVY6CmkaVT
        zhFDIxTBKTu2O/bCmuBBZKwvQhiIFpqyin4XxLq3QUCvRkdCHdrrdFqABBr4QAk0
        cPmNnrJvwrVs8kSg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 687cf3c3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 5 May 2020 21:27:25 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id k6so70303iob.3;
        Tue, 05 May 2020 14:40:00 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ/5GNmN+HWOj29ftogdbWR9vDySa8/yA055uIVV7Q9FjNg0/+1
        0lVD4MN5Z6uyM+79PGVedq1apn7JbzTLuTVcqes=
X-Google-Smtp-Source: APiQypILDb9u5kMainkfXau7Z/NR44IFpUuTQbUhsTXMUW8sLZLa3H7s4lCeFfufo381N7x0WMbXZYL821oSXBjTM8o=
X-Received: by 2002:a6b:7114:: with SMTP id q20mr5360364iog.79.1588714799206;
 Tue, 05 May 2020 14:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200505135947.216022-1-arnd@arndb.de>
In-Reply-To: <20200505135947.216022-1-arnd@arndb.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 5 May 2020 15:39:48 -0600
X-Gmail-Original-Message-ID: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
Message-ID: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
Subject: Re: [PATCH] crypto: curve25519-hacl64 - Disable fortify-source for clang-10
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As discussed on IRC, this issue here isn't specific to this file, but
rather fortify source has some serious issues on clang-10, everywhere
in the kernel, and we should probably disable it globally for this
clang version. I'll follow up with some more info in a different
patch.
