Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1B1C54EBE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 15:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbjAJPy7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 10:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbjAJPy5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 10:54:57 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00CB43E6B
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 07:54:51 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id f34so19115856lfv.10
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 07:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ix339kkTlpn2awHFm+SxDuLq8JxyWGFgKOqLAoyVa7Y=;
        b=dOVMWBGzNqYUYXLR/FTKB5CsJSXGVsyIz6nmC2bcIfxOTCaUynzsUVLboUo0GVzG2i
         6+vL7vdoZWhe44IzF3Mpf/IhwTp79uz0kwya/WXT5bVlQbrkCKe1deWtFSJB2OQDeKzw
         WmbafcqaQYwZT76GLyQrOz7W/0ErkYaE5e3z89jOKDUTlZ3jzocoJM3CyLpwLfmRi+Kt
         IOFEdlMp3D1kv1ZGKxJ3LEkPEqMuprF2qeYY1wlISwNhXMCtO8mHuSrN4PTnWLM3wV7Q
         3W5vsg5cT9NcQqcqW6CpRANTcC3TS93SWoOIFdGNStHfJfA/y3hwkFmSKwRzEhAolLP0
         dEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ix339kkTlpn2awHFm+SxDuLq8JxyWGFgKOqLAoyVa7Y=;
        b=u6HIN3NXNvyq+hU8hEB+eIYEptlnoikYBpq7uU9Zyg4ytHvhi0X9Bp0598yPL8Or7L
         e4SJI+DqK9Z3Cndevjl3OEVu2VbO/z1EXNwk+rVusB2GHhIkG8nz7jLM2+SQKrt/Gxt9
         Sn+KeL+ntjflVvB247dDZCS9IaPmTvTiMgU9/denQ2lVONaXRHYL62Rg24Bs50+xf8fQ
         9BAIDi+G2DLCPSiGtDyiEHn77BwaCmdLmnW6/Qre0FvHaxAEciTlfENBdaqNT5uL/7JL
         ECms6B/7LvALpeZ0dpBgRl2HlBWcHVj0+PI8mLkL0zffs8w/Soytxw6cwrXKMorPok0u
         haDg==
X-Gm-Message-State: AFqh2kpipBssZYMlwjtNzKaNwbf2+IE7/JBSW9B2PCVWGr8U2VWrXuC4
        2NoHraRgWE2DjJuuKMgaMVPGRA==
X-Google-Smtp-Source: AMrXdXvYlXs9NrFjmUAGjtIBjURoNXBjkCKL2q9ffeOwPbmUOMgEN4lMhlAjNtZ6GUXvNZW4ABPz4g==
X-Received: by 2002:a05:6512:3ca0:b0:4b5:b7c3:8053 with SMTP id h32-20020a0565123ca000b004b5b7c38053mr22268123lfv.42.1673366090060;
        Tue, 10 Jan 2023 07:54:50 -0800 (PST)
Received: from localhost (83-245-197-49.elisa-laajakaista.fi. [83.245.197.49])
        by smtp.gmail.com with ESMTPSA id u7-20020ac258c7000000b004a100c21eaesm2239256lfo.97.2023.01.10.07.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 07:54:49 -0800 (PST)
Date:   Tue, 10 Jan 2023 15:54:48 +0000
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] crypto: ccp: Sanitize sev_platform_init() error
 messages
Message-ID: <Y72KSC/Dr55Qszjy@profian.com>
References: <20230110033520.66560-1-jarkko@profian.com>
 <ddbb4b2f-3eb8-64da-bce9-3cfd66d7729a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddbb4b2f-3eb8-64da-bce9-3cfd66d7729a@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 08:41:33AM -0600, Tom Lendacky wrote:
> On 1/9/23 21:35, Jarkko Sakkinen wrote:
> > The following functions end up calling sev_platform_init() or
> > __sev_platform_init_locked():
> > 
> > * sev_guest_init()
> > * sev_ioctl_do_pek_csr
> > * sev_ioctl_do_pdh_export()
> > * sev_ioctl_do_pek_import()
> > * sev_ioctl_do_pek_pdh_gen()
> > * sev_pci_init()
> > 
> > However, only sev_pci_init() prints out the failed command error code, and
> > even there, the error message does not specify which SEV command failed.
> > 
> > Address this by printing out the SEV command errors inside
> > __sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
> > INIT_EX commands.  As a side-effect, @error can be removed from the
> > parameter list.
> > 
> > This extra information is particularly useful if firmware loading and/or
> > initialization is going to be made more robust, e.g. by allowing firmware
> > loading to be postponed.
> > ---
> > v4:
> > * Sorry, v3 was malformed. Here's a proper patch.
> > 
> > v3:
> > * Address Tom Lendacky's feedback:
> >    https://lore.kernel.org/kvm/8bf6f179-eee7-fd86-7892-cdcd76e0762a@amd.com/
> > 
> > v2:
> > * Address David Rientjes's feedback:
> >    https://lore.kernel.org/all/6a16bbe4-4281-fb28-78c4-4ec44c8aa679@google.com/
> > * Remove @error.
> > * Remove "SEV_" prefix: it is obvious from context so no need to make klog
> >    line longer.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> > ---
> >   drivers/crypto/ccp/sev-dev.c | 17 ++++++++++-------
> >   1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 06fc7156c04f..bdc43e75c78b 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -476,19 +476,23 @@ static int __sev_platform_init_locked(int *error)
> >   		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
> >   		rc = init_function(&psp_ret);
> >   	}
> > -	if (error)
> > +	if (rc) {
> > +		dev_err(sev->dev, "SEV: %s failed error %#x",
> > +			sev_init_ex_buffer ? "CMD_INIT_EX" : "CMD_INIT", psp_ret);
> >   		*error = psp_ret;
> 
> If I'm not mistaken, error can be NULL, that's why the "if (error)" was
> present. So that should be kept and even filled in on success. So please
> leave it the way it was and just add the message to the "if (rc)" section.

Ah, right thanks, will do.

> > -
> > -	if (rc)
> >   		return rc;
> > +	}
> >   	sev->state = SEV_STATE_INIT;
> >   	/* Prepare for first SEV guest launch after INIT */
> >   	wbinvd_on_all_cpus();
> > -	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
> > -	if (rc)
> > +	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
> 
> Same here, add:
> 
> 	if (error)
> 		*error = psp_ret;
> > +	if (rc) {
> > +		dev_err(sev->dev, "SEV: CMD_DF_FLUSH failed error %#x", psp_ret);
> > +		*error = psp_ret;
> >   		return rc;
> > +	}
> >   	dev_dbg(sev->dev, "SEV firmware initialized\n");
> > @@ -1337,8 +1341,7 @@ void sev_pci_init(void)
> >   	/* Initialize the platform */
> >   	rc = sev_platform_init(&error);
> >   	if (rc)
> > -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> > -			error, rc);
> > +		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
> >   	return;

BR, Jarkko
