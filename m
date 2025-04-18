Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D2C204C0D
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744976749; cv=none; b=j+MCUgIjswDqCpwQWfOG0MLqYeSbYqpA5GOrZvOA+g6RsL+t5ngTDDmT+iHAvIG+HYV31kfkTxtv1QFUKEMmH0KpD54ZYAo2yWBpqDHcx5I2urEmB3M+bPOzngJGeog0f234JvhoNwM/Z68+HzzdPWbyOXcrkMZVLLFyi/FfZoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744976749; c=relaxed/simple;
	bh=Ry1h7m16FdgxZUCsG/YEor+XDuZU0CwFby5eFpHVpyc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=AJyLDCYc1oF1eATcnlKt4LLeWZNWiulxj2ry44NPkNgA2hNyurRCwfTBT/6712CDV6DzlR408KLps4dxJZvN1SRuAZ4zQsBuWmzbRy1HRmCMtUSkPU6LB1qAnMRx0znTNZLb7JtIRrWbio61c4y2lk8YWrjqXoC48eIBsjBBj7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=xEoGYTdT; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="xEoGYTdT"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1744976732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+pKArFsMcV1twEuEApjeMF+AmY+/ECoXgfNbrjnGlo0=;
	b=xEoGYTdTck1JVn6h6n60BfedloWuXHkfsKcqtmq73RjbFo4SQb+z9FvN8gByieubUonmFn
	h0RFTJQUlY4kC3yshPS9zUr4DwfixrBYwoC+ZD1X1DudPEd/B69asbjW95JUnU47mjFqLy
	DaVkWaYfjuY6uufxZva6Bq27aliOPjh8HmHIYxaZsxcIwHPuK35FLn3jV8ZnMOSFfHnGhr
	uw7eqToGt2hXbjqc1jyhBZUj8vJ7In/Zjmr0cCVFXZMwceu87OLh9xQkLC8v6A5m/B6coR
	FAAMLmfa7cIi3iIpyxwhJzl8jce6rvzyl4QuE26+V3kPuk/ozmNs3G7eBm/F3Q==
Content-Type: multipart/signed;
 boundary=1b697cfb805afad669590ac602a8a82f42215c1070e50bde362d177e9cb2;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 18 Apr 2025 13:45:23 +0200
Message-Id: <D99QMGBHHYJO.1D7D0ZXJLBG9Y@cknow.org>
Cc: <davem@davemloft.net>, <thierry.reding@gmail.com>,
 <jonathanh@nvidia.com>, <linux-crypto@vger.kernel.org>,
 <linux-tegra@vger.kernel.org>, "Dragan Simic" <dsimic@manjaro.org>,
 "Corentin Labbe" <clabbe@baylibre.com>,
 <linux-rockchip@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/10] Tegra Security Engine driver improvements
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
To: "Akhil R" <akhilrajeev@nvidia.com>, <herbert@gondor.apana.org.au>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
In-Reply-To: <20250224091610.49683-1-akhilrajeev@nvidia.com>
X-Migadu-Flow: FLOW_OUT

--1b697cfb805afad669590ac602a8a82f42215c1070e50bde362d177e9cb2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8


Hi,

Earlier today I tried to boot my 6.15-rc1 kernel on my RockPro64
(rk3399) and that didn't go too well:

```
[   13.946999] Unable to handle kernel paging request at virtual address fe=
fefefefefeff46
[   13.947010] Mem abort info:
[   13.947012]   ESR =3D 0x0000000096000044
[   13.947014]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   13.947018]   SET =3D 0, FnV =3D 0
[   13.947020]   EA =3D 0, S1PTW =3D 0
[   13.947022]   FSC =3D 0x04: level 0 translation fault
[   13.947024] Data abort info:
[   13.947026]   ISV =3D 0, ISS =3D 0x00000044, ISS2 =3D 0x00000000
[   13.947029]   CM =3D 0, WnR =3D 1, TnD =3D 0, TagAccess =3D 0
[   13.947031]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
[   13.947034] [fefefefefefeff46] address between user and kernel address r=
anges
[   13.947039] Internal error: Oops: 0000000096000044 [#1]  SMP
[   13.947044] Modules linked in: snd_soc_core(+) dw_hdmi_cec(+) des_generi=
c rockchip_rga gpio_ir_recv leds_gpio(+) panfrost(+) v4l2_vp9 v4l2_h264 ecd=
h_generic snd_compress rk_crypto gpu_sched videobuf2_dma_contig spi_nor(+) =
rfkill snd_pcm_dmaengine videobuf2_dma_sg v4l2_mem2mem drm_shmem_helper vid=
eobuf2_memops snd_pcm crypto_engine rockchip_saradc snd_timer libdes videob=
uf2_v4l2 snd pwrseq_core mtd soundcore videodev industrialio_triggered_buff=
er videobuf2_common kfifo_buf mc coresight_cpu_debug rockchip_thermal cores=
ight_etm4x industrialio coresight cpufreq_dt binfmt_misc pkcs8_key_parser e=
fi_pstore configfs nfnetlink ip_tables x_tables autofs4 ext4 crc16 mbcache =
jbd2 phy_rockchip_samsung_hdptx phy_rockchip_naneng_combphy panel_boe_th101=
mb31ig002_28a xhci_plat_hcd realtek xhci_hcd rockchipdrm dw_hdmi_qp dwmac_r=
k stmmac_platform dw_hdmi rk808_regulator stmmac dwc3 cec fusb302 udc_core =
rc_core ulpi tcpm pcs_xpcs dw_mipi_dsi fan53555 typec analogix_dp phylink p=
hy_rockchip_emmc mdio_devres pwm_regulator dwc3_of_simple
[   13.947183]  drm_display_helper sdhci_of_arasan of_mdio gpio_rockchip sd=
hci_pltfm fixed_phy drm_client_lib ehci_platform ohci_platform fixed drm_dm=
a_helper gpio_keys phy_rockchip_pcie phy_rockchip_inno_usb2 ohci_hcd sdhci =
ehci_hcd drm_kms_helper fwnode_mdio usbcore nvmem_rockchip_efuse phy_rockch=
ip_typec dw_wdt drm pl330 rockchip_dfi io_domain libphy i2c_rk3x cqhci dw_m=
mc_rockchip spi_rockchip pwm_rockchip usb_common dw_mmc_pltfm dw_mmc
[   13.947244] CPU: 5 UID: 0 PID: 617 Comm: cryptomgr_test Tainted: G      =
   C          6.15-rc1+unreleased-arm64-cknow #1 NONE  Debian 6.15~rc1-1~ex=
p1
[   13.947252] Tainted: [C]=3DCRAP
[   13.947254] Hardware name: Pine64 RockPro64 v2.1 (DT)
[   13.947257] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   13.947262] pc : crypto_ahash_init+0x68/0xf0
[   13.947273] lr : crypto_ahash_init+0x50/0xf0
[   13.947277] sp : ffff80008097b950
[   13.947278] x29: ffff80008097b950 x28: 0000000000000000 x27: ffff5e7f8d1=
10200
[   13.947285] x26: 0000000000000014 x25: ffff80008097bb48 x24: ffff5e7f817=
d0400
[   13.947292] x23: ffffd5ef022c5008 x22: 0000000000000000 x21: ffff5e7f8d1=
10610
[   13.947298] x20: ffff5e7f817d0450 x19: fefefefefefefefe x18: 00000000fff=
fffff
[   13.947304] x17: 0000000000000001 x16: ffffd5ef1ee6c8a8 x15: ffff8000809=
7bc78
[   13.947310] x14: ffff80008097baa0 x13: 0000000000000000 x12: 00000000000=
00000
[   13.947316] x11: ffff5e80777cd470 x10: ffff5e80777cd450 x9 : ffffd5ef022=
c50ac
[   13.947322] x8 : ffff80008097ba08 x7 : 0000000000000000 x6 : ffffff79be1=
40702
[   13.947327] x5 : 1032547698badcfe x4 : efcdab8967452301 x3 : 00000000c3d=
2e1f0
[   13.947333] x2 : 0000000000000000 x1 : ffff5e7f8d110400 x0 : 00000000000=
00000
[   13.947339] Call trace:
[   13.947342]  crypto_ahash_init+0x68/0xf0 (P)
[   13.947348]  rk_ahash_init+0x3c/0x58 [rk_crypto]
[   13.947358]  ahash_do_req_chain+0x13c/0x278
[   13.947363]  crypto_ahash_init+0xc4/0xf0
[   13.947367]  test_ahash_vec_cfg+0x340/0x748
[   13.947372]  __alg_test_hash.isra.0+0x1e0/0x3b8
[   13.947375]  alg_test_hash+0xe8/0x130
[   13.947379]  alg_test+0x180/0x710
[   13.947383]  cryptomgr_test+0x2c/0x58
[   13.947389]  kthread+0x120/0x220
[   13.947397]  ret_from_fork+0x10/0x20
[   13.947406] Code: b9002e96 eb13029f 540001c0 f94012a1 (f9002661)=20
[   13.947410] ---[ end trace 0000000000000000 ]---
```

Much more, including full dmesg output can be found at
https://paste.sr.ht/~diederik/f440d669e7f94983b70acebda18a0b9d716f230e

When I mentioned this to Dragan Simic, he noted there were similarities
between Rockchip's crypto engine and Tegra's.
Trying to find a good commit to (shorttrack) a ``git bisect`` operation,
I stumbled upon this patch set. And that just seemed like too much of a
coincidence :-)

I don't have the skills/knowledge to fix this myself, but I was
wondering/hoping you could maybe directly see/point to where things are
going (so) wrong in the Rockchip code?

Thanks in advance,
  Diederik

On Mon Feb 24, 2025 at 10:16 AM CET, Akhil R wrote:
> With the CRYPTO_TEST now being run asynchronously unveiled some
> concurrency issues in the Security Engine driver. These were not
> caught during functional or fuzz testing as all the tests were run
> synchronously.
>
> This patchset contains the fixes for the concurrency issues and few
> other improvements identified during the stress-ng and cryptsetup tests.
>
> ---
>
> Akhil R (10):
>   crypto: tegra: Use separate buffer for setkey
>   crypto: tegra: Do not use fixed size buffers
>   crypto: tegra: finalize crypto req on error
>   crypto: tegra: check return value for hash do_one_req
>   crypto: tegra: Transfer HASH init function to crypto engine
>   crypto: tegra: Fix HASH intermediate result handling
>   crypto: tegra: Fix CMAC intermediate result handling
>   crypto: tegra: Set IV to NULL explicitly for AES ECB
>   crypto: tegra: Reserve keyslots to allocate dynamically
>   crypto: tegra: Use HMAC fallback when keyslots are full
>
>  drivers/crypto/tegra/tegra-se-aes.c  | 401 ++++++++++++++++++---------
>  drivers/crypto/tegra/tegra-se-hash.c | 287 ++++++++++++-------
>  drivers/crypto/tegra/tegra-se-key.c  |  27 +-
>  drivers/crypto/tegra/tegra-se-main.c |  16 +-
>  drivers/crypto/tegra/tegra-se.h      |  39 ++-
>  5 files changed, 523 insertions(+), 247 deletions(-)


--1b697cfb805afad669590ac602a8a82f42215c1070e50bde362d177e9cb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCaAI7VgAKCRDXblvOeH7b
bnlmAQCZE3ooULP3BkjzEPOsJBp2ZB5l3ncqiOxI1MXlJtoZcAD+Km+imkb91I0p
lDUO5FnFCynorpXbTC9a0sjrgQD06wk=
=atQd
-----END PGP SIGNATURE-----

--1b697cfb805afad669590ac602a8a82f42215c1070e50bde362d177e9cb2--
