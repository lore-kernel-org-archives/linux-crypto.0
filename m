Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792767729;
	b=wHHWPtbV4xWHCzAgbjiKF+illjujxOpclAdZA5aDX9EZtvBEQ0aoFfvByAxri5D6Eizq
	 0EdauW6Vtu3wHqnupY49iv36b7GhCyXloCtF+qJf2dep7y0Qd6gUCJwgzhCMrLKNpl35y
	 3oOvIoiIYiHq7BfqpCn6TikiY1GWeCTW9NG+z+veelNm3BroD13vEKOJR0Q2Xo3MNt9iF
	 R5XZxTOscrMGNEdLEO5jY1l8dKkI4U9Y+J/Aez4xyMjvPXscd0wNjA2cZVj47ICGXtZjo
	 NYhfEdUAuJaIVSnQKa3IKMrQLpy1g6XZI1FJmKAKxvjN6wM5J+6wu0uAkcu29ZA4pfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792767729;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=40npNaO/CAIYgaafFVlOFrpqvGXYpB6rCNNlSz+oZlI=;
	b=ECWtSIg4CMItes2V9kbUVQvzM8k8csh8A1s+RS77Vvg9v6syg2ugXf6kX6rPWYija7Qs
	 z+x5jasiWndYpe3l6pfgO5DrI9HzXljzHKbAVbXu1IhIIifM9mSCZWX6Ejdo/aPsFC035
	 MUzVpz1j5oxJk0UPPr/bYBildBDBHwTpYnuLLdsstBQhfE/9TP0otnyNHR/6nfMpVX731
	 PCmjLMPuLSUyvGydR0/f98tRFbBM94MDtzomAhtovXwWamG8koF3Ort0JEH+DFAZYLg1/
	 6lVGphoQE+8KirOkEZta85rQsw7ClxMgwV2XN9n7pd3lDc6KjHa2l27y4vEXP81Y30g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UsI/kHRK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE3606A31B
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UsI/kHRK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FF31F01825;
	Fri, 23 Oct 2026 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792767728;
	bh=40npNaO/CAIYgaafFVlOFrpqvGXYpB6rCNNlSz+oZlI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UsI/kHRKVvy5B0X45pDxIep+XAywRrtKzCLsA7AKKeRR4k/mpKi+xsbQprQD/6bko
	 N07beNh2V7aAj3U/WkELVqvKk9hDs7d5jhIC/sKG9tXYTcunBE58xckWo5c6y1vXEr
	 q4kTm8N6EwNbzXxYcF1El/9/ISt2KYatsV/sG71SEOR/oMkomlJtwA0kGMEn5uBvO/
	 goY+L9B4eutV6cKt69uzFajRRoO5MURCXkrKt3+OME0GHZL1OK3OyKFJZROriglnVC
	 DfoMMA+J/PAH/RnnA0dE0WXSPffu36e1qtDRNwFYYAQNr8v26CFeBiMPBWjrriSeBF
	 xFcV9lz7XIqcQ==
Message-ID: <sashiko-outbox-182888@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND 2/2] Documentation: qat: document three-service
 mode for QAT GEN5 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ahsan Atta" <ahsan.atta@intel.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, "Bairavi Alagappan" <bairavix.alagappan@intel.com>, "Giovanni
 Cabiddu" <giovanni.cabiddu@intel.com>
In-Reply-To: <20261023144835.170453-3-ahsan.atta@intel.com>
References: <20261023144835.170453-1-ahsan.atta@intel.com>
 <20261023144835.170453-3-ahsan.atta@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 15:02:07 +0000
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
- [Medium] crypto: qat - stale rl_data.svc_ae_mask in adf_420xx_dev_config()
--

commit 0c0ee10ffff8629021fbc1b8499eb78f471d4264
Author: Bairavi Alagappan <bairavix.alagappan@intel.com>

Documentation: qat: document three-service mode for QAT GEN5 devices

This commit updates the sysfs ABI documentation for cfg_services to note
that QAT GEN5 devices (qat_420xx driver) support combining up to three
concurrent services.

> diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/A=
BI/testing/sysfs-driver-qat
> index b0561b9fc4eb9..48e17de3e0fdb 100644
> --- a/Documentation/ABI/testing/sysfs-driver-qat
> +++ b/Documentation/ABI/testing/sysfs-driver-qat
> @@ -41,8 +41,8 @@ Description:	(RW) Reports the current configuration of =
the QAT device.
> =20
>  		Service combinations are permitted for all services except dcc.
>  		On QAT GEN4 devices (qat_4xxx driver) a maximum of two services can be
> -		combined and on QAT GEN6 devices (qat_6xxx driver ) a maximum of three
> -		services can be combined.
> +		combined. On QAT GEN5 devices (qat_420xx driver) and GEN6 devices
> +		(qat_6xxx driver) a maximum of three services can be combined.

[Severity: Medium]
When reconfiguring cfg_services on a QAT 420xx device from three-service
mode (sym;asym;dc) back to a one- or two-service mode via sysfs, does
rl_data.svc_ae_mask retain stale three-service engine counts?

During probe, adf_probe() -> adf_init_hw_data_420xx() -> adf_init_rl_data()
calls adf_gen4_init_num_svc_aes(), initializing hw_data->rl_data.svc_ae_mask
to 16 worker engines for each service.

When a user configures three-service mode via cfg_services and brings the
device up via state_store() -> adf_dev_up() -> adf_420xx_dev_config(),
rl_data.svc_ae_mask is overwritten in-place by adf_update_rl_data() with the
three-service engine counts (4 for asym, 4 for sym, and 8 for dc):

drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c:
static int adf_420xx_dev_config(struct adf_accel_dev *accel_dev)
{
	int ret;

	ret =3D adf_gen4_dev_config(accel_dev);
	if (ret)
		return ret;

	if (adf_get_service_enabled(accel_dev) =3D=3D SVC_SYM_ASYM_DC)
		adf_update_rl_data(&GET_HW_DATA(accel_dev)->rl_data);

	return 0;
}

If the user then brings the device down, changes cfg_services back to a
one- or two-service configuration (such as sym;asym or dc), and brings the
device up again, adf_get_service_enabled(accel_dev) is no longer
SVC_SYM_ASYM_DC, and nothing in adf_420xx_dev_config(), adf_dev_down(), or
adf_dev_up() resets rl_data.svc_ae_mask.

When adf_rl_start() or subsequent SLA operations calculate rate-limiting
cycle budgets in drivers/crypto/intel/qat/qat_common/adf_rl.c:

adf_rl_calculate_ae_cycles() {
	...
	avail_ae_cycles =3D hw_data->clock_frequency;
	avail_ae_cycles *=3D adf_rl_get_num_svc_aes(accel_dev, svc_type);
	do_div(avail_ae_cycles, device_data->scan_interval);
	...
}

wouldn't adf_rl_get_num_svc_aes() read the stale three-service svc_ae_mask
values and under-allocate SLA cycle budgets (1/4 of the intended budget for
sym/asym and 1/2 for dc), and should adf_420xx_dev_config() have an else
branch calling adf_gen4_init_num_svc_aes(&GET_HW_DATA(accel_dev)->rl_data)
to restore svc_ae_mask?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023144835.1704=
53-1-ahsan.atta@intel.com?part=3D2
