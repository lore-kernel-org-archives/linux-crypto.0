Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005177;
	b=eVwfhbYsRFC/OOjPpOlL/SeYhjTusThbRZWUXhlsj6g89Iw8xnLSh20fZNr8cWo2B6jQ
	 gYeyQ3xhJpbZcXGZ/ElVFKPKjLjfxuKV47/BE14Mp+ZmRSmpZabkxbaqPKs2CaWYOs/Qx
	 Kne6jj5kkG+8oIa512kJncaN59TwB78NHnDBIlOymdWI+3ae3RQhE+IBzGJrM6m9ILoaG
	 0KI6wgjIZgKoW9yXAalMQz5J2ePfQ3p7/C4T0tsp4jOG1ki6+a+gT0/HiJIZW00N0iYCC
	 B/5YWv9xZp64Ij+e0txysUp0UdmijX84Npcu1RcqS1RFvafri9tTrwNc4qLShg7BYQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005177;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l1mnqCn4BmGu8ewdxcbpE/BgyGtayOJ1f2zuV/xugEk=;
	b=xN37tgMBSCvmpruqFmF8hwF9DUHfcLik4rBmRvtoyaCLcCVSb2rVYPdC/nyfj7L2A+xs
	 vUzvzRaE/GK2B1dH624wiH4xKE//G/IthEj4/FMw3/kzhDzKvqHV4CG7PH3LnKrcE9caW
	 McrrjxyLyRAD23dZXKry6lKVyB3N+ydGn8RMm4HLv1NI2OzvvKNm9m5SB9G2DUmCW5Rps
	 bJKWtn1qtQORkip1ZK1T25FTmzjYtxXjwEi9/0h27lHLmYw28QFtOB1a+aAwpXag0DaVA
	 jOzIbtNp+GCq2acTdze8/gaAy07GoqrRv3euLfOT3bI29oL5Tj+Xjjl3vBUKmM078mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOWu6WIQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A6C606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOWu6WIQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB31F01825;
	Mon, 26 Oct 2026 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005176;
	bh=l1mnqCn4BmGu8ewdxcbpE/BgyGtayOJ1f2zuV/xugEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NOWu6WIQ51i/WQq9c38j7WrjOZWpcna+W9oBx/DxfyX7ZN+hE21js7un+pa8/g8O3
	 JVV3hy+NcP2chiX9zwPhXy5AEzwUKyhfHqGjkfXpGshn+DR4w4ic/g585j6nA71cDZ
	 LY98VZv/gWvKp55GsuIZ/btBLpZg9TsVTShASIVMfIQIM7sfNFIg9627I2onMHW2hj
	 5+0JljOM6L/1Kcz9otgwhtLTWTTtk8dlO/fJVbiYzPwpviO4keTqrWNqBGvYmw1atE
	 Hc91P+mdTZ41tOaRPBqhPVszmQ1G/bNzUnB6rV8zB3/9P1JEQrRDtdsfgb6pRPr6XC
	 wdZUdWE0s8s+A==
Message-ID: <sashiko-outbox-184716@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: qat - add support for enhanced decompression
 mode on GEN6 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suman Kumar Chakraborty" <suman.kumar.chakraborty@intel.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, "Karthikeyan Gopal" <karthikeyan.gopal@intel.com>, "Giovanni
 Cabiddu" <giovanni.cabiddu@intel.com>
In-Reply-To: <20261026035501.1627846-1-suman.kumar.chakraborty@intel.com>
References: <20261026035501.1627846-1-suman.kumar.chakraborty@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:59:36 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] crypto: qat - missing state_lock in decomp_enhanced_store() races =
with down/up
- [Medium] crypto: qat - decomp_enhanced_store() sends FW cmd without dc or=
 decomp
- [Medium] crypto: qat: missing firmware rollback in decomp_enhanced_store()
--

commit 2bd7b68e36bc7513f2621d0b0db284e20b70faca
Author: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>

crypto: qat - add support for enhanced decompression mode on GEN6 devices

This commit adds support for enhanced decompression mode on QAT GEN6
devices via the ICP_QAT_FW_CNV_BYPASS_MODE_SET firmware admin command and
exposes it through a new decomp_enhanced sysfs attribute.

> diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drive=
rs/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
> index 388087e64540e..0bf4907a32764 100644
> --- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
> +++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c

[ ... ]

> @@ -1064,7 +1080,8 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_dat=
a *hw_data)
>  	hw_data->num_rps =3D ADF_GEN6_ETR_MAX_BANKS;
>  	hw_data->clock_frequency =3D ADF_6XXX_AE_FREQ;
>  	hw_data->get_svc_slice_cnt =3D adf_gen6_get_svc_slice_cnt;
> -	hw_data->accel_capabilities_ext_mask =3D ADF_ACCEL_CAPABILITIES_EXT_ZST=
D;
> +	hw_data->accel_capabilities_ext_mask =3D ADF_ACCEL_CAPABILITIES_EXT_ZST=
D |
> +					       ADF_ACCEL_CAPABILITIES_EXT_ENHANCED_DECOMP;
> =20
>  	adf_gen6_init_services_supported(hw_data);
>  	adf_gen6_init_hw_csr_ops(&hw_data->csr_ops);

[Severity: Medium]
Does setting ADF_ACCEL_CAPABILITIES_EXT_ENHANCED_DECOMP unconditionally in
adf_init_hw_data_6xxx() expose the decomp_enhanced sysfs attribute on GEN6
SKUs that do not support compression, such as wireless crypto SKUs where
adf_6xxx_is_wcy(hw_data) is true or devices with ICP_ACCEL_GEN6_MASK_CPR_SL=
ICE
set in hw_data->fuses[ADF_FUSECTL1]?

> diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/cr=
ypto/intel/qat/qat_common/adf_sysfs.c
> index 8daa69a76b01a..ab3f17c878bb7 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c

[ ... ]

> @@ -321,6 +322,70 @@ static ssize_t num_rps_show(struct device *dev, stru=
ct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(num_rps);
> =20
> +static ssize_t decomp_enhanced_show(struct device *dev, struct device_at=
tribute *attr,
> +				    char *buf)
> +{
> +	struct adf_accel_dev *accel_dev;
> +
> +	accel_dev =3D adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
> +	if (!accel_dev)
> +		return -EINVAL;
> +
> +	return sysfs_emit(buf, "%s\n", str_on_off(adf_is_decomp_enhanced(accel_=
dev)));
> +}
> +
> +static ssize_t decomp_enhanced_store(struct device *dev, struct device_a=
ttribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct adf_accel_dev *accel_dev;
> +	unsigned long mask;
> +	bool enabled;
> +	int ret;
> +
> +	ret =3D kstrtobool(buf, &enabled);
> +	if (ret)
> +		return ret;
> +
> +	accel_dev =3D adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
> +	if (!accel_dev)
> +		return -EINVAL;
> +
> +	if (adf_devmgr_in_reset(accel_dev))
> +		return -EBUSY;
> +
> +	if (enabled) {
> +		ret =3D adf_get_service_mask(accel_dev, &mask);
> +		if (ret)
> +			return ret;
> +
> +		if (!(mask & (BIT(SVC_DC) | BIT(SVC_DECOMP)))) {
> +			dev_err(&GET_DEV(accel_dev),
> +				"decomp_enhanced requires dc or decomp service\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* If the device is down the value is picked up by adf_send_admin_init(=
). */
> +	if (adf_dev_started(accel_dev)) {
> +		ret =3D adf_send_admin_decomp_enhanced(accel_dev, enabled);

[Severity: Medium]
When enabled is false and the device is started without dc or decomp
configured (for example, sym;asym, dcc, or sym on a WCY SKU), will this
still send ICP_QAT_FW_CNV_BYPASS_MODE_SET to the firmware?

Because the service mask check is only performed inside the if (enabled)
block, writing 0 or off on a started device without dc or decomp still
calls adf_send_admin_decomp_enhanced(accel_dev, false), whereas the ABI
documentation in Documentation/ABI/testing/sysfs-driver-qat states that
the setting has no effect while neither dc nor decomp is configured.

> +		if (ret) {
> +			dev_err(&GET_DEV(accel_dev),
> +				"Failed to program enhanced decompression: %d\n",
> +				ret);
> +			return ret;
> +		}
> +	}
> +
> +	ret =3D adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
> +					  ADF_DECOMP_ENHANCED,
> +					  enabled ? "1" : "0", ADF_STR);
> +	if (ret)
> +		return ret;

[Severity: High]
Can decomp_enhanced_store() race with adf_dev_down() and adf_dev_up()
because it does not hold accel_dev->state_lock?

In drivers/crypto/intel/qat/qat_common/adf_init.c, adf_dev_down() holds
accel_dev->state_lock while calling adf_dev_stop() and adf_dev_shutdown():

drivers/crypto/intel/qat/qat_common/adf_init.c:adf_dev_down() {
	mutex_lock(&accel_dev->state_lock);

	adf_dev_stop(accel_dev);
	adf_dev_shutdown(accel_dev);

	mutex_unlock(&accel_dev->state_lock);
}

And adf_dev_shutdown() calls adf_exit_admin_comms(), which frees
accel_dev->admin and sets it to NULL:

drivers/crypto/intel/qat/qat_common/adf_admin.c:adf_exit_admin_comms() {
	...
	if (admin->virt_addr)
		dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
				  admin->virt_addr, admin->phy_addr);
	...
	mutex_destroy(&admin->lock);
	kfree(admin);
	accel_dev->admin =3D NULL;
}

If decomp_enhanced_store() checks adf_dev_started(accel_dev) without
holding accel_dev->state_lock, a concurrent adf_dev_down() can stop the
engines and run adf_exit_admin_comms() while decomp_enhanced_store() calls
adf_send_admin_decomp_enhanced() -> adf_send_admin() ->
adf_put_admin_msg_sync(), which unconditionally dereferences
accel_dev->admin.

Similarly, during adf_dev_up() -> adf_dev_start(), hw_data->send_admin_init=
()
runs while ADF_STATUS_STARTING is set and before ADF_STATUS_STARTED is
set. If decomp_enhanced_store() runs in that window, adf_dev_started()
returns false, so it skips adf_send_admin_decomp_enhanced() and updates
ADF_DECOMP_ENHANCED in accel_dev->cfg after adf_send_admin_init() has
already completed, leaving the firmware and configuration out of sync
(which can also happen if two concurrent writers on separate file
descriptors interleave adf_send_admin_decomp_enhanced() and
adf_cfg_add_key_value_param()).

[Severity: Medium]
Also in decomp_enhanced_store(), what happens if
adf_cfg_add_key_value_param() fails with -ENOMEM when kzalloc_obj(*key_val)
fails in drivers/crypto/intel/qat/qat_common/adf_cfg.c after
adf_send_admin_decomp_enhanced() has already reprogrammed the firmware?

Would that leave the running firmware's enhanced decompression mode out of
sync with the configuration stored in accel_dev->cfg and reported by
decomp_enhanced_show()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026035501.1627=
846-1-suman.kumar.chakraborty@intel.com?part=3D1
