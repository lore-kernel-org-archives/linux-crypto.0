Return-Path: <SRS0=e/ms=UJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEB0C4321B
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 21:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83C2B21721
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 21:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ijZRqYOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbfFJVct (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 17:32:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:47033 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389784AbfFJVct (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 17:32:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so6008455pfy.13
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2019 14:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u65kJhZ2c0w54Nc/i9RYT+l58N6im9e9Q29G/YH/uuc=;
        b=ijZRqYOHAJLGYs5vVBH7AyvxnX3poiS7Ze8fMa8xMMZFUFQkNHIHUJuCZa0E+HU7KK
         ZEEdHPDvfDlVSbqAvrXP3rviz6pH3j9htRBPT5NIqJKjGJE+FjxllNFI8RlkWV1QA19g
         aArbTyQM1D+rcblnoPAFTe/gzDozuxJ5mSkQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u65kJhZ2c0w54Nc/i9RYT+l58N6im9e9Q29G/YH/uuc=;
        b=ZkH7b+2cLCwkCnsALosYUD0Wf+S1PzwhiCMpxZpwswH8VFtoSb2Cz4YOruvN7aO5GI
         sJdtwLABlcnZTmKjq6fMgoQHRDl7ndw1TDm/O7aXD/2w9eEphK32qyNSBQLDwGBQy0o+
         sFkHNLIrPuzRNPRAG1mgyeHS4YSOxGTg6nUa5yVy8Qf1944DcTutszEukd1Wjd+9fXpu
         j1CSnMQf64aGpIAiwFdET4/73SE5HbQTMd3PwLO3X1PWk6j2NenAvpqbrP4dEnvzTRb1
         u6upGMXuVDY11B94xI4iqraRknXnlaBhSBpABV9WDhv+O12hYYtHYeHD0UUTqNq8OVgu
         gT0Q==
X-Gm-Message-State: APjAAAULpM2GV3UWMF258HhuEexILZYDeyfVvfrNHtLVA4anvB6y3xkS
        Q1K3GatnjM13mOb02pBTdNG2AQ==
X-Google-Smtp-Source: APXvYqyQzwsz4g4vXj8Aq9NRG67WJeqq4COKYtOvIJxo3DWxXcQEhMnNrnrMg8J5OGqUXm+tPqrSlw==
X-Received: by 2002:aa7:8145:: with SMTP id d5mr77831178pfn.11.1560202368916;
        Mon, 10 Jun 2019 14:32:48 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id q1sm18907954pfb.156.2019.06.10.14.32.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Jun 2019 14:32:48 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:32:47 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Garnier <thgarnie@chromium.org>
Cc:     kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Alok Kataria <akataria@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Garnier <thgarnie@google.com>,
        Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Tang <feng.tang@intel.com>,
        Jan Beulich <JBeulich@suse.com>,
        Maran Wilson <maran.wilson@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v7 00/12] x86: PIE support to extend KASLR randomization
Message-ID: <201906101432.B642E297F@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 20, 2019 at 04:19:25PM -0700, Thomas Garnier wrote:
> Splitting the previous serie in two. This part contains assembly code
> changes required for PIE but without any direct dependencies with the
> rest of the patchset.

Thanks for doing this! It should be easier to land the "little" fixes so
there's less to review for the big PIE changes down the road.

-- 
Kees Cook
