Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD36C77B60
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 15:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbjDEPhH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238698AbjDEPhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 11:37:06 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B99B6A47
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 08:37:04 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id he13so1520237wmb.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680709022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T5c+mNA6XY8wWRzkfZN072IgeaVS0xxX0AuG9Rc8s3Y=;
        b=hxKiJK155vYGbPwdzRmDCUiWyNZbG3wukTsi0I6XWU1DKdfAnkq5nWIAm3DB4EHZU1
         hirqMIbrtM5n61hEYk2ikAcX1fckKmRWVnKXogyDi7RnUYcodZWpte/nbyhVpCDMzzXU
         /QcLUWksBNjDMT8zYtMqtFv0QPFkZiqzGEI6fjgwWIURijiUBJUIdp5eJVEqIUh6ADuU
         8qBGePxy0bgwur+kNXliiyRCD9so9ZDfN7yG+Le+ZkUPJ/iPAGYbbT7ufog5IAKFtaKE
         crVgIE49ef3OQ4wz2me77wt9zM9ZryNZw+pXCpIiFaWduEdNywug/sDDujT48AXZN0P+
         JPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5c+mNA6XY8wWRzkfZN072IgeaVS0xxX0AuG9Rc8s3Y=;
        b=v4i68NDspQbs+0ZMR2u+OdSrfviQy8Xqx/NQMDonodgn9ATPO8IQj0G2mEq4bITgqQ
         qoSmkXgBgeP+VGSvQjguAkIlbn9dLomULeI0r73yyTH8bax4sR+kVBH+G5kkKt7Qk0e8
         TAYcw8IPLQ+IiQKxoVeqdHsBldJGmIkaM4ZyrPNAbaoC3sdlcnao/VibjEDWvLHoos9g
         SyqnBhhNe8eC8VC/hX/G3NURRmWZKvuxzpWHMFiEcK5iA17vAaCHScIf/n+Fek1qQbxt
         t+ovkkjqdeI8kazbcyMDY8BXAaTYnTg9+b45sXHhzGjqcm2APIPGtZyy+PnbXDSNCcqX
         Q7EQ==
X-Gm-Message-State: AAQBX9cm3wRjJ3kCSrVm9DAVytcSFRP+gz5GkhTuxrtQtkI0zv7y09OB
        h7aW8sCMH5io5ccgDS+wZQdcZw==
X-Google-Smtp-Source: AKy350a3Rz0tEpg+tSdGOZ4GFjJ3hB0PumjkJW94dJW2rUvZU2nc+5RfxVg2opTda9VASWMRks1Myg==
X-Received: by 2002:a1c:7501:0:b0:3dc:433a:e952 with SMTP id o1-20020a1c7501000000b003dc433ae952mr4664257wmc.33.1680709022536;
        Wed, 05 Apr 2023 08:37:02 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c35c600b003ede03e4369sm2582875wmq.33.2023.04.05.08.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:37:02 -0700 (PDT)
Date:   Wed, 5 Apr 2023 17:37:01 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     Sunil V L <sunilvl@ventanamicro.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-acpi@vger.kernel.org, linux-crypto@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, llvm@lists.linux.dev,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Tom Rix <trix@redhat.com>, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Len Brown <lenb@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH V4 13/23] RISC-V: cpufeature: Add ACPI support in
 riscv_fill_hwcap()
Message-ID: <fajw3nx5d6u32qvsb2uaysayiadqf5eelfjxc4lokjcrsvddad@cfyp2gwviocd>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
 <20230404182037.863533-14-sunilvl@ventanamicro.com>
 <20230404-promotion-scarce-7c69ff7e5f99@spud>
 <ZC15LqYqLzmiVdcr@sunil-laptop>
 <20230405-compel-slinky-2fe11b4bf0b3@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405-compel-slinky-2fe11b4bf0b3@spud>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 05, 2023 at 03:31:24PM +0100, Conor Dooley wrote:
> On Wed, Apr 05, 2023 at 07:05:42PM +0530, Sunil V L wrote:
> > On Tue, Apr 04, 2023 at 09:57:19PM +0100, Conor Dooley wrote:
> > > On Tue, Apr 04, 2023 at 11:50:27PM +0530, Sunil V L wrote:
...
> > > > -		if (of_property_read_string(node, "riscv,isa", &isa)) {
> > > > -			pr_warn("Unable to find \"riscv,isa\" devicetree entry\n");
> > > > -			continue;
> > > > +		if (acpi_disabled) {
> > > > +			node = of_cpu_device_node_get(cpu);
> > > > +			if (node) {
> > > > +				rc = of_property_read_string(node, "riscv,isa", &isa);
> > > 
> > > Hmm, after digging in the previous patch, I think this is actually not
> > > possible to fail? We already validated it when setting up the mask of
> > > possible cpus, but I think leaving the error handling here makes things
> > > a lot more obvious.
> > > 
> > Yeah, do you prefer to merge these patches again since only in this
> > patch, we change the loop to for_each_possible_cpu() from
> > for_each_of_cpu_node() which actually makes riscv_of_processor_hartid()
> > not useful?
> 
> Yah, all 3 of us mistakenly thought that that was an unrelated cleanup
> on the last revision, but clearly it is not.
> Squash it back IMO, sorry for my part in the extra work generated.

Yup, please squash back in. Sorry about that, Sunil!

drew
