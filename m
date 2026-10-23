Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792767790;
	b=ID40DpmFCmUBoEMyKKVLc86qlVW+NB2GX7kBXNWKnR69n/IwQrMfN8c26tlQ0yCUjbpY
	 IJbbNqSdGToFAbqPWpvxbhb0bW9/wl7HKxnfxlt0uHfao+xSo8wPMo8sBpho6b43+TlrT
	 eWlIL9pvwS/7jRke+WHVqADWQgXZT2OELlbHVM6NEHHXMMRyhiL0uLzx/XmSJxckQnmyl
	 kRhhhIODPmLqEQJ1Sg4CrA4Err0yJRm2IZfcbzy6UiRPT764lJeHjBXoKgH8BDvtruifQ
	 Yr7DNRMmuXvdSrqJe4VZh/zCygg55bsHDEb1GmHem30H3BpAzA3aMLz2p5yKIooRhJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792767790;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z7qR/v0wocJ0R3JNIRj87WuyPyBlIUOLaKSV/MnntGc=;
	b=4dVmJ2izGWQeROl9zEs9h6xIWDvb5EUrDjLYERJuWgFjx2wDtrShJmhU1KT+T1maSYBY
	 pxmyYkucttgpPrINBPMkY3grkvEU+I0LcVvhCSDp2Sylz0Zg13PoXNskT6/TXByOQ2UEv
	 ydrrDp+3rmeWuT12sjGDhLtuhYglC+Iru0v1ASW1o01wnDOEMzY3Cuk0vPv5zfU8V9gcV
	 p8wUUr59iFCmbk+Oh1nD5y3yPsYsEj1WWo5cJzJf1+/DQv+2Njlq5SLTBVu/Idul683eG
	 w+yieF8Twgcp7GFP7n1pANizQCWKbWn6swJzNEgZLQeUtrJI9ejPSXsHRaFAwNyKNSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5QIUU6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED01606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5QIUU6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5741F01825;
	Fri, 23 Oct 2026 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792767789;
	bh=z7qR/v0wocJ0R3JNIRj87WuyPyBlIUOLaKSV/MnntGc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P5QIUU6vqN5MvC2GMA/8+YbXDMDSclbTncdYjzVztXYRLM9gA1hxtKsgFKGRiPPCz
	 gCejJZyP9EdqErSYh6eFrON5mxWYrXdc7E3dYCM0Po7Bf7X1NniV7MnmPQSjVYATnz
	 jgsqT1T2JupesuzanUzKMDwTqF6TQFahyXF6LlM93mrq0fiFhYYoFwmGdDOzwTH2+t
	 Tn68xQjuAzLZsF1KwyEv0eGSU0IMThdnp8u6uZ3GCVFwxXYV7WqRNEwCB5eK+85ct3
	 3EnpVxEG3rJDOoArDdTlSOmGunDqlY8N3BbRMBbE8M18YV0ac9P0Rw9aPPnW+zvP30
	 DDDwO7IDe2xUA==
Message-ID: <sashiko-outbox-182890@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND 1/2] crypto: qat - enable three-service mode for
 QAT GEN5 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ahsan Atta" <ahsan.atta@intel.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, "Bairavi Alagappan" <bairavix.alagappan@intel.com>, "Giovanni
 Cabiddu" <giovanni.cabiddu@intel.com>
In-Reply-To: <20261023144835.170453-2-ahsan.atta@intel.com>
References: <20261023144835.170453-1-ahsan.atta@intel.com>
 <20261023144835.170453-2-ahsan.atta@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 15:03:08 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] crypto: qat - unrestored rl_data.svc_ae_mask in adf_420xx_dev_co=
nfig()
--

commit 84452d0273c635ae08ee4c142e1d46cbf85da2de
Author: Bairavi Alagappan <bairavix.alagappan@intel.com>

crypto: qat - enable three-service mode for QAT GEN5 devices

This commit adds support for enabling symmetric crypto, asymmetric crypto,
and compression services concurrently on QAT GEN5 (qat_420xx) devices. It
defines the firmware object layout, ring-to-service mapping,
thread-to-arbiter mapping, and rate-limiting accelerator engine accounting
for three-service mode.

> diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/dri=
vers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> index 19f9f738630b1..281067f5b60c5 100644
> --- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> +++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c

[ ... ]

> @@ -425,6 +450,79 @@ static void adf_gen4_set_err_mask(struct adf_dev_err=
_mask *dev_err_mask)

[ ... ]

> +static void adf_update_rl_data(struct adf_rl_hw_data *rl_data)
> +{
> +	unsigned int num_groups;
> +	unsigned int i;
> +
> +	num_groups =3D ARRAY_SIZE(adf_fw_asym_sym_dc_config) - ADF_GEN4_ADMIN_A=
CCELENGINES;
> +
> +	memset(rl_data->svc_ae_mask, 0, sizeof(rl_data->svc_ae_mask));
> +
> +	for (i =3D 0; i < num_groups; i++) {
> +		switch (adf_fw_asym_sym_dc_config[i].obj) {
> +		case ADF_FW_ASYM_OBJ:
> +			rl_data->svc_ae_mask[SVC_ASYM] +=3D
> +				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
> +			break;
> +		case ADF_FW_SYM_OBJ:
> +			rl_data->svc_ae_mask[SVC_SYM] +=3D
> +				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
> +			break;
> +		case ADF_FW_DC_OBJ:
> +			rl_data->svc_ae_mask[SVC_DC] +=3D
> +				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
> +
> +static int adf_420xx_dev_config(struct adf_accel_dev *accel_dev)
> +{
> +	int ret;
> +
> +	ret =3D adf_gen4_dev_config(accel_dev);
> +	if (ret)
> +		return ret;
> +
> +	if (adf_get_service_enabled(accel_dev) =3D=3D SVC_SYM_ASYM_DC)
> +		adf_update_rl_data(&GET_HW_DATA(accel_dev)->rl_data);
> +
> +	return 0;
> +}

[Severity: Medium]
During probe, adf_init_hw_data_420xx() -> adf_init_rl_data() ->
adf_gen4_init_num_svc_aes() initializes rl_data.svc_ae_mask to ae_cnt - 1
(16 on an unfused 420xx device) for SVC_ASYM, SVC_SYM, and SVC_DC.

When the device is brought down via sysfs, configured to SVC_SYM_ASYM_DC,
and brought back up via state_store() -> adf_dev_up(accel_dev, true) ->
adf_420xx_dev_config(), adf_update_rl_data() overwrites rl_data.svc_ae_mask
in-place with {SVC_ASYM: 4, SVC_SYM: 4, SVC_DC: 8, SVC_DECOMP: 0}.

If the device is subsequently brought down, reconfigured via cfg_services
to a 1-service or 2-service mode, and brought back up,
adf_420xx_dev_config() has no else branch (such as calling
adf_gen4_init_num_svc_aes()) to restore rl_data.svc_ae_mask.

Additionally, if cfg_services is modified while the device is down and
SR-IOV is then enabled, adf_sriov_configure() -> adf_do_enable_sriov()
brings the device up with config set to false:

drivers/crypto/intel/qat/qat_common/adf_sriov.c:adf_do_enable_sriov() {
	...
	ret =3D adf_dev_up(accel_dev, false);
	...
}

which bypasses adf_420xx_dev_config() and adf_update_rl_data() before
adf_rl_start() initializes rate limiting.

In both cases, adf_rl_calculate_ae_cycles() will read stale AE counts via
adf_rl_get_num_svc_aes():

drivers/crypto/intel/qat/qat_common/adf_rl.c:adf_rl_calculate_ae_cycles() {
	...
	avail_ae_cycles =3D hw_data->clock_frequency;
	avail_ae_cycles *=3D adf_rl_get_num_svc_aes(accel_dev, svc_type);
	do_div(avail_ae_cycles, device_data->scan_interval);
	...
}

Can this cause miscalculated rate-limiting AE cycle budgets (ae_util_cir
and ae_util_pir) to be programmed into firmware after service
reconfiguration or when enabling SR-IOV?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023144835.1704=
53-1-ahsan.atta@intel.com?part=3D1
