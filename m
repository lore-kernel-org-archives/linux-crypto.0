Return-Path: <SRS0=xlaa=2U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B540C2D0C2
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 18:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1312071E
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 18:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bHZS9r+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfL3Swb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 13:52:31 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33881 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbfL3Swb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 13:52:31 -0500
Received: by mail-ot1-f65.google.com with SMTP id a15so47289952otf.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Dec 2019 10:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2PU80e06dVsLEFBPoBP15a3a0bqTWpgCtffJm4G5PGU=;
        b=bHZS9r+DC7xoeD6cxpH4i3xpSJ/gq50CwlupX1697alL9zoV2RniiOpeS0fzfamIQa
         WxQ7cCBNSANfXeX4NY4r/hZFK4P1w1JlyzXv9TnOkQRK0d1M4ZscNJljNFAQFM5GFlOM
         35xcjwPPMRp352B/JuDt4EKyWZZ4Uo+a1Db+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2PU80e06dVsLEFBPoBP15a3a0bqTWpgCtffJm4G5PGU=;
        b=sq7kzq7qmwBMZF4z+K0J5bPAp2/foecPnF81iMA7Lu5F85sRX+80S7Zu9CSa+33R1+
         L6bVJ35Jo+8fg4/bMfB2lLpbUOeMw2rpm2aE7Y2o4Ky/gMwMCkKroMM7pkdUWgpE3GiV
         s71FbZXC+IH9vCmqdo0HsQeGk9iNHaryB1LIa2HLOCZ14u2CRJIc54fb1mnN1xlUBe5v
         1fLu6pPMyPvRyzktTaLDc/8hfV90Cp8ADeN7RUOBTBrFicooAA9r1w9dtQwSH2FZLUFX
         vAIUaOtBuWsZbRDmtWiGJQ+M/cRj/+KsQKD7aEnnPHGTzhXhFcIG6/20HfUuuKaPVIHA
         dNCA==
X-Gm-Message-State: APjAAAVeUus0InGbfJv5gZdj2UyHguDscrwK5XVw1o4lhdZTylWIH7M6
        fYjjDkhURQ8ljhH5K6MGfPBBQY8sy8M=
X-Google-Smtp-Source: APXvYqyRXCmINU65Y6yuKMiO/XiDPdUu64Vn+VoIxbx6ttD2OgkwUiThd7nh2RnWqHJyh6C1czL/mQ==
X-Received: by 2002:a9d:748d:: with SMTP id t13mr73212089otk.181.1577731950592;
        Mon, 30 Dec 2019 10:52:30 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r13sm13994800oic.52.2019.12.30.10.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:52:29 -0800 (PST)
Date:   Mon, 30 Dec 2019 10:52:28 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Garnier <thgarnie@chromium.org>,
        kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v10 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <201912301052.16438D6@keescook>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191224130310.GE21017@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224130310.GE21017@zn.tnic>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 24, 2019 at 02:03:10PM +0100, Borislav Petkov wrote:
> On Wed, Dec 04, 2019 at 04:09:37PM -0800, Thomas Garnier wrote:
> > Minor changes based on feedback and rebase from v9.
> > 
> > Splitting the previous serie in two. This part contains assembly code
> > changes required for PIE but without any direct dependencies with the
> > rest of the patchset.
> 
> Ok, modulo the minor commit message and comments fixup, this looks ok
> and passes testing here.
> 
> I'm going to queue patches 2-11 of the next version unless someone
> complains.

Great! Thanks very much for the reviews. :)

-- 
Kees Cook
