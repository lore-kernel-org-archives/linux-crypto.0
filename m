Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FD3C4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 09:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiKGJZ5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiKGJZa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 04:25:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED0017A88
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 01:24:56 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78hIqT019241;
        Mon, 7 Nov 2022 09:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=1GP5oLjW+q4z6Y6F9jjv6ZOPhx8/mC2xmtqjchsPzhk=;
 b=WDnLxnymlDBW84KUPv+7xEGJdGTsQEydCMqHeJoPya8xCMux345McYv0fp8GVbk+Ockt
 lNX8l2lFE1f0zxcd7Qs1pYBBtGT9oS2NsCvXT0LS+YpVKwDEhPBF38vgP6b+96gU5T8w
 o4ZAyPUSvG4EyiLdTUjNLisGuadGcdMNxaMRxhWmSlnyz2O/NCzBmtNL3sl19V26vt+f
 nU/WBk3TR7MGe/2gfe1jCViSwOMHGdILtRygkI2QCUGzOvy4jAUSrtRICOq79FfQZkTX
 9slW5UEcKCSQTDnpWCSquSZxigANrULMBDykF4GE89XNzTze8q+84v5R6n/R/f0iFbNf XQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1w84awx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:24:44 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A79KSwN000667;
        Mon, 7 Nov 2022 09:24:44 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3kngs3pqd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:24:44 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A79Ohxp23331400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 09:24:43 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C4D158062;
        Mon,  7 Nov 2022 09:24:43 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6D4958051;
        Mon,  7 Nov 2022 09:24:42 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 09:24:42 +0000 (GMT)
MIME-Version: 1.0
Date:   Mon, 07 Nov 2022 10:24:42 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH] hw_random: treat default_quality as a maximum and default
 to 1024
Reply-To: freude@linux.ibm.com
In-Reply-To: <20221104154230.52836-1-Jason@zx2c4.com>
References: <20221104154230.52836-1-Jason@zx2c4.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <a0863b503b22b42fb8129b6847188a2e@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cqlA9aMk0T-y1YP-aZxD-EIpI8sq3BNA
X-Proofpoint-ORIG-GUID: cqlA9aMk0T-y1YP-aZxD-EIpI8sq3BNA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 mlxscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-11-04 16:42, Jason A. Donenfeld wrote:
> Most hw_random devices return entropy which is assumed to be of full
> quality, but driver authors don't bother setting the quality knob. Some
> hw_random devices return less than full quality entropy, and then 
> driver
> authors set the quality knob. Therefore, the entropy crediting should 
> be
> opt-out rather than opt-in per-driver, to reflect the actual reality on
> the ground.
> 
> For example, the two Raspberry Pi RNG drivers produce full entropy
> randomness, and both EDK2 and U-Boot's drivers for these treat them as
> such. The result is that EFI then uses these numbers and passes the to
> Linux, and Linux credits them as boot, thereby initializing the RNG.
> Yet, in Linux, the quality knob was never set to anything, and so on 
> the
> chance that Linux is booted without EFI, nothing is ever credited.
> That's annoying.
> 
> The same pattern appears to repeat itself throughout various drivers. 
> In
> fact, very very few drivers have bothered setting quality=1024.
> 
> So let's invert this logic. A hw_random struct's quality knob now
> controls the maximum quality a driver can produce, or 0 to specify 
> 1024.
> Then, the module-wide switch called "default_quality" is changed to
> represent the maximum quality of any driver. By default it's 1024, and
> the quality of any particular driver is then given by:
> 
>     min(default_quality, rng->quality ?: 1024);
> 
> This way, the user can still turn this off for weird reasons, yet we 
> get
> proper crediting for relevant RNGs.
> 
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/um/drivers/random.c           | 1 -
>  drivers/char/hw_random/core.c      | 9 +++------
>  drivers/char/hw_random/mpfs-rng.c  | 1 -
>  drivers/char/hw_random/s390-trng.c | 1 -
>  drivers/crypto/atmel-sha204a.c     | 1 -
>  drivers/crypto/caam/caamrng.c      | 1 -
>  drivers/firmware/turris-mox-rwtm.c | 1 -
>  drivers/usb/misc/chaoskey.c        | 1 -
>  include/linux/hw_random.h          | 2 +-
>  9 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
> index 32b3341fe970..da985e0dc69a 100644
> --- a/arch/um/drivers/random.c
> +++ b/arch/um/drivers/random.c
> @@ -82,7 +82,6 @@ static int __init rng_init (void)
>  	sigio_broken(random_fd);
>  	hwrng.name = RNG_MODULE_NAME;
>  	hwrng.read = rng_dev_read;
> -	hwrng.quality = 1024;
> 
>  	err = hwrng_register(&hwrng);
>  	if (err) {
> diff --git a/drivers/char/hw_random/core.c 
> b/drivers/char/hw_random/core.c
> index cc002b0c2f0c..afde685f5e0a 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -41,14 +41,14 @@ static DEFINE_MUTEX(reading_mutex);
>  static int data_avail;
>  static u8 *rng_buffer, *rng_fillbuf;
>  static unsigned short current_quality;
> -static unsigned short default_quality; /* = 0; default to "off" */
> +static unsigned short default_quality = 1024; /* default to maximum */
> 
>  module_param(current_quality, ushort, 0644);
>  MODULE_PARM_DESC(current_quality,
>  		 "current hwrng entropy estimation per 1024 bits of input --
> obsolete, use rng_quality instead");
>  module_param(default_quality, ushort, 0644);
>  MODULE_PARM_DESC(default_quality,
> -		 "default entropy content of hwrng per 1024 bits of input");
> +		 "default maximum entropy content of hwrng per 1024 bits of input");
> 
>  static void drop_current_rng(void);
>  static int hwrng_init(struct hwrng *rng);
> @@ -170,10 +170,7 @@ static int hwrng_init(struct hwrng *rng)
>  	reinit_completion(&rng->cleanup_done);
> 
>  skip_init:
> -	if (!rng->quality)
> -		rng->quality = default_quality;
> -	if (rng->quality > 1024)
> -		rng->quality = 1024;
> +	rng->quality = min_t(u16, min_t(u16, default_quality, 1024),
> rng->quality ?: 1024);
>  	current_quality = rng->quality; /* obsolete */
> 
>  	return 0;
> diff --git a/drivers/char/hw_random/mpfs-rng.c
> b/drivers/char/hw_random/mpfs-rng.c
> index 5813da617a48..c6972734ae62 100644
> --- a/drivers/char/hw_random/mpfs-rng.c
> +++ b/drivers/char/hw_random/mpfs-rng.c
> @@ -78,7 +78,6 @@ static int mpfs_rng_probe(struct platform_device 
> *pdev)
> 
>  	rng_priv->rng.read = mpfs_rng_read;
>  	rng_priv->rng.name = pdev->name;
> -	rng_priv->rng.quality = 1024;
> 
>  	platform_set_drvdata(pdev, rng_priv);
> 
> diff --git a/drivers/char/hw_random/s390-trng.c
> b/drivers/char/hw_random/s390-trng.c
> index 795853dfc46b..cffa326ddc8d 100644
> --- a/drivers/char/hw_random/s390-trng.c
> +++ b/drivers/char/hw_random/s390-trng.c
> @@ -191,7 +191,6 @@ static struct hwrng trng_hwrng_dev = {
>  	.name		= "s390-trng",
>  	.data_read	= trng_hwrng_data_read,
>  	.read		= trng_hwrng_read,
> -	.quality	= 1024,
>  };
> 
> 
> diff --git a/drivers/crypto/atmel-sha204a.c 
> b/drivers/crypto/atmel-sha204a.c
> index a84b657598c6..c0103e7fc2e7 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -107,7 +107,6 @@ static int atmel_sha204a_probe(struct i2c_client 
> *client,
> 
>  	i2c_priv->hwrng.name = dev_name(&client->dev);
>  	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
> -	i2c_priv->hwrng.quality = 1024;
> 
>  	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
>  	if (ret)
> diff --git a/drivers/crypto/caam/caamrng.c 
> b/drivers/crypto/caam/caamrng.c
> index 77d048dfe5d0..1f0e82050976 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -246,7 +246,6 @@ int caam_rng_init(struct device *ctrldev)
>  	ctx->rng.cleanup = caam_cleanup;
>  	ctx->rng.read    = caam_read;
>  	ctx->rng.priv    = (unsigned long)ctx;
> -	ctx->rng.quality = 1024;
> 
>  	dev_info(ctrldev, "registering rng-caam\n");
> 
> diff --git a/drivers/firmware/turris-mox-rwtm.c
> b/drivers/firmware/turris-mox-rwtm.c
> index c2d34dc8ba46..6ea5789a89e2 100644
> --- a/drivers/firmware/turris-mox-rwtm.c
> +++ b/drivers/firmware/turris-mox-rwtm.c
> @@ -528,7 +528,6 @@ static int turris_mox_rwtm_probe(struct
> platform_device *pdev)
>  	rwtm->hwrng.name = DRIVER_NAME "_hwrng";
>  	rwtm->hwrng.read = mox_hwrng_read;
>  	rwtm->hwrng.priv = (unsigned long) rwtm;
> -	rwtm->hwrng.quality = 1024;
> 
>  	ret = devm_hwrng_register(dev, &rwtm->hwrng);
>  	if (ret < 0) {
> diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
> index 87067c3d6109..6fb5140e29b9 100644
> --- a/drivers/usb/misc/chaoskey.c
> +++ b/drivers/usb/misc/chaoskey.c
> @@ -200,7 +200,6 @@ static int chaoskey_probe(struct usb_interface 
> *interface,
> 
>  	dev->hwrng.name = dev->name ? dev->name : chaoskey_driver.name;
>  	dev->hwrng.read = chaoskey_rng_read;
> -	dev->hwrng.quality = 1024;
> 
>  	dev->hwrng_registered = (hwrng_register(&dev->hwrng) == 0);
>  	if (!dev->hwrng_registered)
> diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> index 77c2885c4c13..8a3115516a1b 100644
> --- a/include/linux/hw_random.h
> +++ b/include/linux/hw_random.h
> @@ -34,7 +34,7 @@
>   * @priv:		Private data, for use by the RNG driver.
>   * @quality:		Estimation of true entropy in RNG's bitstream
>   *			(in bits of entropy per 1024 bits of input;
> - *			valid values: 1 to 1024, or 0 for unknown).
> + *			valid values: 1 to 1024, or 0 for maximum).
>   */
>  struct hwrng {
>  	const char *name;

Well, I am not sure if this is the right way to go. So by default a
hw rng which does not implement the registration correctly is
rewarded with the implicit assumption that it produces 100% of
entropy.
I see your point - a grep through the kernel code gives the impression
that a whole bunch of registrations is done with an empty quality
field. What about assuming a default quality of 50% if the field
is not filled ?
