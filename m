Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58C3BB13A;
	Wed, 19 Aug 2026 02:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787107091; cv=none; b=bb+O7IMLDXb/scomp1vl37gsG3115jamKxVV0l3D3iBDabjHy6WK5cekPhVAL5zX3/z2x3qyT8R/GeMWGTCcftTx9HlZ9QlQqzt//Mj8Q+S9Ov/4eBEuy1+cFf5Ma3B3cwlgGymAnRSHIG567BbkSFnqdRYIuUo39FRcwL+w0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787107091; c=relaxed/simple;
	bh=/v809CBajN+i6B4Gz3WXBX09oGmIYNAG4x/4uGnsJZg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l4IlnZqiGj3gLsy37yBEfdrZSHNlsUw7B6GVS/524fTyY3XAOQcvYOUlB4qkdFGkJsQ7cbd+BpCoZ7ud//UXApa8qQEg4w3gZ45C+N4mK35fhhLwzg35B+d62TOEAoofX+oQ1K1EkCTD4mcsbOdKiZLORkfunVUux23PBlz0WPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=XyITgusU; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="XyITgusU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TggFt66d9hZA3My8noSquv+CwCz/iPDuvGUbZmWtmNE=;
	b=XyITgusU6RCS6+RKqGEI2LlVg2+3ZsWuOx4rl4kzJ4x+ps4mVc3XC/1U7XE9ejR3aFvxoO4sP
	Egvoue3wtt8M/Ne++H34U9chuy6S6qX1i13k/aLuMSwTzdsqZVPa+X2UJn+VeLcyz2wqtVC3D0p
	XDHrVqVpn/DtJTdqryW5d6I=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hPr7P0207zRhR0;
	Wed, 19 Aug 2026 10:27:13 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D10940561;
	Wed, 19 Aug 2026 10:37:52 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Aug 2026 10:37:51 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec - remove SEC crypto block cipher
 accelerator
To: Chenghai Huang <huangchenghai2@huawei.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<xuwei5@huawei.com>, <prime.zeng@hisilicon.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <20260818083132.1860726-1-huangchenghai2@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f95aedb9-4fb9-e347-1d0c-7eabd9a32a6f@huawei.com>
Date: Wed, 19 Aug 2026 10:37:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260818083132.1860726-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/8/18 16:31, Chenghai Huang Wrote:
> The Hisilicon SEC crypto cipher accelerator has been superseded
> by the newer SEC2 driver (drivers/crypto/hisilicon/sec2/). SEC2
> provides wider algorithm coverage and is the maintained path forward,
> and users have migrated to it.
> 
> The legacy SEC driver has had no active users for some time, and its
> primary maintainer, Jonathan Cameron, has moved on from Huawei and
> is no longer in a position to maintain it. With thanks to Jonathan
> for his contributions to this driver over the years, and with no one
> left to keep it up to date, remove it from the tree.
> 
> This drops the legacy SEC driver together with all of its residual
> configuration, devicetree binding and board description references:
> 
>   - drivers/crypto/hisilicon/sec/
>   - CONFIG_CRYPTO_DEV_HISI_SEC Kconfig option
>   - sec/ entry from drivers/crypto/hisilicon/Makefile
>   - Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>   - hisilicon,hip07-sec device nodes and their supporting mbigen_alg /
>     smmu_alg infrastructure from arch/arm64/boot/dts/hisilicon/hip07.dtsi
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  .../bindings/crypto/hisilicon,hip06-sec.yaml  |  134 --
>  arch/arm64/boot/dts/hisilicon/hip07.dtsi      |  280 ----
>  drivers/crypto/hisilicon/Kconfig              |   14 -
>  drivers/crypto/hisilicon/Makefile             |    1 -
>  drivers/crypto/hisilicon/sec/Makefile         |    3 -
>  drivers/crypto/hisilicon/sec/sec_algs.c       | 1122 --------------
>  drivers/crypto/hisilicon/sec/sec_drv.c        | 1307 -----------------
>  drivers/crypto/hisilicon/sec/sec_drv.h        |  428 ------
>  8 files changed, 3289 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>  delete mode 100644 drivers/crypto/hisilicon/sec/Makefile
>  delete mode 100644 drivers/crypto/hisilicon/sec/sec_algs.c
>  delete mode 100644 drivers/crypto/hisilicon/sec/sec_drv.c
>  delete mode 100644 drivers/crypto/hisilicon/sec/sec_drv.h
>

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.

> diff --git a/Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml b/Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
> deleted file mode 100644
> index 2bfac9d1c020..000000000000
> --- a/Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
> +++ /dev/null
> @@ -1,134 +0,0 @@
> -# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> -%YAML 1.2
> ----
> -$id: http://devicetree.org/schemas/crypto/hisilicon,hip06-sec.yaml#
> -$schema: http://devicetree.org/meta-schemas/core.yaml#
> -
> -title: Hisilicon hip06/hip07 Security Accelerator
> -
> -maintainers:
> -  - Jonathan Cameron <Jonathan.Cameron@huawei.com>
> -
> -properties:
> -  compatible:
> -    enum:
> -      - hisilicon,hip06-sec
> -      - hisilicon,hip07-sec
> -
> -  reg:
> -    items:
> -      - description: Registers for backend processing engines
> -      - description: Registers for common functionality
> -      - description: Registers for queue 0
> -      - description: Registers for queue 1
> -      - description: Registers for queue 2
> -      - description: Registers for queue 3
> -      - description: Registers for queue 4
> -      - description: Registers for queue 5
> -      - description: Registers for queue 6
> -      - description: Registers for queue 7
> -      - description: Registers for queue 8
> -      - description: Registers for queue 9
> -      - description: Registers for queue 10
> -      - description: Registers for queue 11
> -      - description: Registers for queue 12
> -      - description: Registers for queue 13
> -      - description: Registers for queue 14
> -      - description: Registers for queue 15
> -
> -  interrupts:
> -    items:
> -      - description: SEC unit error queue interrupt
> -      - description: Completion interrupt for queue 0
> -      - description: Error interrupt for queue 0
> -      - description: Completion interrupt for queue 1
> -      - description: Error interrupt for queue 1
> -      - description: Completion interrupt for queue 2
> -      - description: Error interrupt for queue 2
> -      - description: Completion interrupt for queue 3
> -      - description: Error interrupt for queue 3
> -      - description: Completion interrupt for queue 4
> -      - description: Error interrupt for queue 4
> -      - description: Completion interrupt for queue 5
> -      - description: Error interrupt for queue 5
> -      - description: Completion interrupt for queue 6
> -      - description: Error interrupt for queue 6
> -      - description: Completion interrupt for queue 7
> -      - description: Error interrupt for queue 7
> -      - description: Completion interrupt for queue 8
> -      - description: Error interrupt for queue 8
> -      - description: Completion interrupt for queue 9
> -      - description: Error interrupt for queue 9
> -      - description: Completion interrupt for queue 10
> -      - description: Error interrupt for queue 10
> -      - description: Completion interrupt for queue 11
> -      - description: Error interrupt for queue 11
> -      - description: Completion interrupt for queue 12
> -      - description: Error interrupt for queue 12
> -      - description: Completion interrupt for queue 13
> -      - description: Error interrupt for queue 13
> -      - description: Completion interrupt for queue 14
> -      - description: Error interrupt for queue 14
> -      - description: Completion interrupt for queue 15
> -      - description: Error interrupt for queue 15
> -
> -  dma-coherent: true
> -
> -  iommus:
> -    maxItems: 1
> -
> -required:
> -  - compatible
> -  - reg
> -  - interrupts
> -  - dma-coherent
> -
> -additionalProperties: false
> -
> -examples:
> -  - |
> -    bus {
> -        #address-cells = <2>;
> -        #size-cells = <2>;
> -
> -        crypto@400d2000000 {
> -            compatible = "hisilicon,hip07-sec";
> -            reg = <0x400 0xd0000000 0x0 0x10000
> -                  0x400 0xd2000000 0x0 0x10000
> -                  0x400 0xd2010000 0x0 0x10000
> -                  0x400 0xd2020000 0x0 0x10000
> -                  0x400 0xd2030000 0x0 0x10000
> -                  0x400 0xd2040000 0x0 0x10000
> -                  0x400 0xd2050000 0x0 0x10000
> -                  0x400 0xd2060000 0x0 0x10000
> -                  0x400 0xd2070000 0x0 0x10000
> -                  0x400 0xd2080000 0x0 0x10000
> -                  0x400 0xd2090000 0x0 0x10000
> -                  0x400 0xd20a0000 0x0 0x10000
> -                  0x400 0xd20b0000 0x0 0x10000
> -                  0x400 0xd20c0000 0x0 0x10000
> -                  0x400 0xd20d0000 0x0 0x10000
> -                  0x400 0xd20e0000 0x0 0x10000
> -                  0x400 0xd20f0000 0x0 0x10000
> -                  0x400 0xd2100000 0x0 0x10000>;
> -            interrupts = <576 4>,
> -                        <577 1>, <578 4>,
> -                        <579 1>, <580 4>,
> -                        <581 1>, <582 4>,
> -                        <583 1>, <584 4>,
> -                        <585 1>, <586 4>,
> -                        <587 1>, <588 4>,
> -                        <589 1>, <590 4>,
> -                        <591 1>, <592 4>,
> -                        <593 1>, <594 4>,
> -                        <595 1>, <596 4>,
> -                        <597 1>, <598 4>,
> -                        <599 1>, <600 4>,
> -                        <601 1>, <602 4>,
> -                        <603 1>, <604 4>,
> -                        <605 1>, <606 4>,
> -                        <607 1>, <608 4>;
> -            dma-coherent;
> -            iommus = <&p1_smmu_alg_a 0x600>;
> -        };
> -    };
> diff --git a/arch/arm64/boot/dts/hisilicon/hip07.dtsi b/arch/arm64/boot/dts/hisilicon/hip07.dtsi
> index 00a6bfa7478c..d175e242ee96 100644
> --- a/arch/arm64/boot/dts/hisilicon/hip07.dtsi
> +++ b/arch/arm64/boot/dts/hisilicon/hip07.dtsi
> @@ -1113,74 +1113,6 @@ mbigen_usb: intc_usb {
>  			num-pins = <2>;
>  		};
>  	};
> -	p0_mbigen_alg_a:interrupt-controller@d0080000 {
> -		compatible = "hisilicon,mbigen-v2";
> -		reg = <0x0 0xd0080000 0x0 0x10000>;
> -
> -		p0_mbigen_sec_a: intc_sec {
> -			msi-parent = <&p0_its_dsa_a 0x40400>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <33>;
> -		};
> -		p0_mbigen_smmu_alg_a: intc_smmu_alg {
> -			msi-parent = <&p0_its_dsa_a 0x40b1b>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <3>;
> -		};
> -	};
> -	p0_mbigen_alg_b:interrupt-controller@8,d0080000 {
> -		compatible = "hisilicon,mbigen-v2";
> -		reg = <0x8 0xd0080000 0x0 0x10000>;
> -
> -		p0_mbigen_sec_b: intc_sec {
> -			msi-parent = <&p0_its_dsa_b 0x42400>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <33>;
> -		};
> -		p0_mbigen_smmu_alg_b: intc_smmu_alg {
> -			msi-parent = <&p0_its_dsa_b 0x42b1b>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <3>;
> -		};
> -	};
> -	p1_mbigen_alg_a:interrupt-controller@400,d0080000 {
> -		compatible = "hisilicon,mbigen-v2";
> -		reg = <0x400 0xd0080000 0x0 0x10000>;
> -
> -		p1_mbigen_sec_a: intc_sec {
> -			msi-parent = <&p1_its_dsa_a 0x44400>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <33>;
> -		};
> -		p1_mbigen_smmu_alg_a: intc_smmu_alg {
> -			msi-parent = <&p1_its_dsa_a 0x44b1b>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <3>;
> -		};
> -	};
> -	p1_mbigen_alg_b:interrupt-controller@408,d0080000 {
> -		compatible = "hisilicon,mbigen-v2";
> -		reg = <0x408 0xd0080000 0x0 0x10000>;
> -
> -		p1_mbigen_sec_b: intc_sec {
> -			msi-parent = <&p1_its_dsa_b 0x46400>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <33>;
> -		};
> -		p1_mbigen_smmu_alg_b: intc_smmu_alg {
> -			msi-parent = <&p1_its_dsa_b 0x46b1b>;
> -			interrupt-controller;
> -			#interrupt-cells = <2>;
> -			num-pins = <3>;
> -		};
> -	};
>  	p0_mbigen_dsa_a: interrupt-controller@c0080000 {
>  		compatible = "hisilicon,mbigen-v2";
>  		reg = <0x0 0xc0080000 0x0 0x10000>;
> @@ -1237,54 +1169,6 @@ smmu0: iommu@a0040000 {
>  		hisilicon,broken-prefetch-cmd;
>  		status = "disabled";
>  	};
> -	p0_smmu_alg_a: iommu@d0040000 {
> -		compatible = "arm,smmu-v3";
> -		reg = <0x0 0xd0040000 0x0 0x20000>;
> -		interrupt-parent = <&p0_mbigen_smmu_alg_a>;
> -		interrupts = <733 1>,
> -		<734 1>,
> -		<735 1>;
> -		interrupt-names = "eventq", "gerror", "priq";
> -		#iommu-cells = <1>;
> -		dma-coherent;
> -		hisilicon,broken-prefetch-cmd;
> -	};
> -	p0_smmu_alg_b: iommu@8d0040000 {
> -		compatible = "arm,smmu-v3";
> -		reg = <0x8 0xd0040000 0x0 0x20000>;
> -		interrupt-parent = <&p0_mbigen_smmu_alg_b>;
> -		interrupts = <733 1>,
> -		<734 1>,
> -		<735 1>;
> -		interrupt-names = "eventq", "gerror", "priq";
> -		#iommu-cells = <1>;
> -		dma-coherent;
> -		hisilicon,broken-prefetch-cmd;
> -	};
> -	p1_smmu_alg_a: iommu@400d0040000 {
> -		compatible = "arm,smmu-v3";
> -		reg = <0x400 0xd0040000 0x0 0x20000>;
> -		interrupt-parent = <&p1_mbigen_smmu_alg_a>;
> -		interrupts = <733 1>,
> -		<734 1>,
> -		<735 1>;
> -		interrupt-names = "eventq", "gerror", "priq";
> -		#iommu-cells = <1>;
> -		dma-coherent;
> -		hisilicon,broken-prefetch-cmd;
> -	};
> -	p1_smmu_alg_b: iommu@408d0040000 {
> -		compatible = "arm,smmu-v3";
> -		reg = <0x408 0xd0040000 0x0 0x20000>;
> -		interrupt-parent = <&p1_mbigen_smmu_alg_b>;
> -		interrupts = <733 1>,
> -		<734 1>,
> -		<735 1>;
> -		interrupt-names = "eventq", "gerror", "priq";
> -		#iommu-cells = <1>;
> -		dma-coherent;
> -		hisilicon,broken-prefetch-cmd;
> -	};
>  
>  	soc {
>  		compatible = "simple-bus";
> @@ -1745,170 +1629,6 @@ p0_pcie2_a: pcie@af800000 {
>  					 0x0 0 0 4 &mbigen_pcie2_a 671 4>;
>  			status = "disabled";
>  		};
> -		p0_sec_a: crypto@d0000000 {
> -			compatible = "hisilicon,hip07-sec";
> -			reg = <0x0 0xd0000000 0x0 0x10000>,
> -			      <0x0 0xd2000000 0x0 0x10000>,
> -			      <0x0 0xd2010000 0x0 0x10000>,
> -			      <0x0 0xd2020000 0x0 0x10000>,
> -			      <0x0 0xd2030000 0x0 0x10000>,
> -			      <0x0 0xd2040000 0x0 0x10000>,
> -			      <0x0 0xd2050000 0x0 0x10000>,
> -			      <0x0 0xd2060000 0x0 0x10000>,
> -			      <0x0 0xd2070000 0x0 0x10000>,
> -			      <0x0 0xd2080000 0x0 0x10000>,
> -			      <0x0 0xd2090000 0x0 0x10000>,
> -			      <0x0 0xd20a0000 0x0 0x10000>,
> -			      <0x0 0xd20b0000 0x0 0x10000>,
> -			      <0x0 0xd20c0000 0x0 0x10000>,
> -			      <0x0 0xd20d0000 0x0 0x10000>,
> -			      <0x0 0xd20e0000 0x0 0x10000>,
> -			      <0x0 0xd20f0000 0x0 0x10000>,
> -			      <0x0 0xd2100000 0x0 0x10000>;
> -			interrupt-parent = <&p0_mbigen_sec_a>;
> -			iommus = <&p0_smmu_alg_a 0x600>;
> -			dma-coherent;
> -			interrupts = <576 4>,
> -				     <577 1>, <578 4>,
> -				     <579 1>, <580 4>,
> -				     <581 1>, <582 4>,
> -				     <583 1>, <584 4>,
> -				     <585 1>, <586 4>,
> -				     <587 1>, <588 4>,
> -				     <589 1>, <590 4>,
> -				     <591 1>, <592 4>,
> -				     <593 1>, <594 4>,
> -				     <595 1>, <596 4>,
> -				     <597 1>, <598 4>,
> -				     <599 1>, <600 4>,
> -				     <601 1>, <602 4>,
> -				     <603 1>, <604 4>,
> -				     <605 1>, <606 4>,
> -				     <607 1>, <608 4>;
> -		};
> -		p0_sec_b: crypto@8d0000000 {
> -			compatible = "hisilicon,hip07-sec";
> -			reg = <0x8 0xd0000000 0x0 0x10000>,
> -			      <0x8 0xd2000000 0x0 0x10000>,
> -			      <0x8 0xd2010000 0x0 0x10000>,
> -			      <0x8 0xd2020000 0x0 0x10000>,
> -			      <0x8 0xd2030000 0x0 0x10000>,
> -			      <0x8 0xd2040000 0x0 0x10000>,
> -			      <0x8 0xd2050000 0x0 0x10000>,
> -			      <0x8 0xd2060000 0x0 0x10000>,
> -			      <0x8 0xd2070000 0x0 0x10000>,
> -			      <0x8 0xd2080000 0x0 0x10000>,
> -			      <0x8 0xd2090000 0x0 0x10000>,
> -			      <0x8 0xd20a0000 0x0 0x10000>,
> -			      <0x8 0xd20b0000 0x0 0x10000>,
> -			      <0x8 0xd20c0000 0x0 0x10000>,
> -			      <0x8 0xd20d0000 0x0 0x10000>,
> -			      <0x8 0xd20e0000 0x0 0x10000>,
> -			      <0x8 0xd20f0000 0x0 0x10000>,
> -			      <0x8 0xd2100000 0x0 0x10000>;
> -			interrupt-parent = <&p0_mbigen_sec_b>;
> -			iommus = <&p0_smmu_alg_b 0x600>;
> -			dma-coherent;
> -			interrupts = <576 4>,
> -				     <577 1>, <578 4>,
> -				     <579 1>, <580 4>,
> -				     <581 1>, <582 4>,
> -				     <583 1>, <584 4>,
> -				     <585 1>, <586 4>,
> -				     <587 1>, <588 4>,
> -				     <589 1>, <590 4>,
> -				     <591 1>, <592 4>,
> -				     <593 1>, <594 4>,
> -				     <595 1>, <596 4>,
> -				     <597 1>, <598 4>,
> -				     <599 1>, <600 4>,
> -				     <601 1>, <602 4>,
> -				     <603 1>, <604 4>,
> -				     <605 1>, <606 4>,
> -				     <607 1>, <608 4>;
> -		};
> -		p1_sec_a: crypto@400d0000000 {
> -			compatible = "hisilicon,hip07-sec";
> -			reg = <0x400 0xd0000000 0x0 0x10000>,
> -			      <0x400 0xd2000000 0x0 0x10000>,
> -			      <0x400 0xd2010000 0x0 0x10000>,
> -			      <0x400 0xd2020000 0x0 0x10000>,
> -			      <0x400 0xd2030000 0x0 0x10000>,
> -			      <0x400 0xd2040000 0x0 0x10000>,
> -			      <0x400 0xd2050000 0x0 0x10000>,
> -			      <0x400 0xd2060000 0x0 0x10000>,
> -			      <0x400 0xd2070000 0x0 0x10000>,
> -			      <0x400 0xd2080000 0x0 0x10000>,
> -			      <0x400 0xd2090000 0x0 0x10000>,
> -			      <0x400 0xd20a0000 0x0 0x10000>,
> -			      <0x400 0xd20b0000 0x0 0x10000>,
> -			      <0x400 0xd20c0000 0x0 0x10000>,
> -			      <0x400 0xd20d0000 0x0 0x10000>,
> -			      <0x400 0xd20e0000 0x0 0x10000>,
> -			      <0x400 0xd20f0000 0x0 0x10000>,
> -			      <0x400 0xd2100000 0x0 0x10000>;
> -			interrupt-parent = <&p1_mbigen_sec_a>;
> -			iommus = <&p1_smmu_alg_a 0x600>;
> -			dma-coherent;
> -			interrupts = <576 4>,
> -				     <577 1>, <578 4>,
> -				     <579 1>, <580 4>,
> -				     <581 1>, <582 4>,
> -				     <583 1>, <584 4>,
> -				     <585 1>, <586 4>,
> -				     <587 1>, <588 4>,
> -				     <589 1>, <590 4>,
> -				     <591 1>, <592 4>,
> -				     <593 1>, <594 4>,
> -				     <595 1>, <596 4>,
> -				     <597 1>, <598 4>,
> -				     <599 1>, <600 4>,
> -				     <601 1>, <602 4>,
> -				     <603 1>, <604 4>,
> -				     <605 1>, <606 4>,
> -				     <607 1>, <608 4>;
> -		};
> -		p1_sec_b: crypto@408d0000000 {
> -			compatible = "hisilicon,hip07-sec";
> -			reg = <0x408 0xd0000000 0x0 0x10000>,
> -			      <0x408 0xd2000000 0x0 0x10000>,
> -			      <0x408 0xd2010000 0x0 0x10000>,
> -			      <0x408 0xd2020000 0x0 0x10000>,
> -			      <0x408 0xd2030000 0x0 0x10000>,
> -			      <0x408 0xd2040000 0x0 0x10000>,
> -			      <0x408 0xd2050000 0x0 0x10000>,
> -			      <0x408 0xd2060000 0x0 0x10000>,
> -			      <0x408 0xd2070000 0x0 0x10000>,
> -			      <0x408 0xd2080000 0x0 0x10000>,
> -			      <0x408 0xd2090000 0x0 0x10000>,
> -			      <0x408 0xd20a0000 0x0 0x10000>,
> -			      <0x408 0xd20b0000 0x0 0x10000>,
> -			      <0x408 0xd20c0000 0x0 0x10000>,
> -			      <0x408 0xd20d0000 0x0 0x10000>,
> -			      <0x408 0xd20e0000 0x0 0x10000>,
> -			      <0x408 0xd20f0000 0x0 0x10000>,
> -			      <0x408 0xd2100000 0x0 0x10000>;
> -			interrupt-parent = <&p1_mbigen_sec_b>;
> -			iommus = <&p1_smmu_alg_b 0x600>;
> -			dma-coherent;
> -			interrupts = <576 4>,
> -				     <577 1>, <578 4>,
> -				     <579 1>, <580 4>,
> -				     <581 1>, <582 4>,
> -				     <583 1>, <584 4>,
> -				     <585 1>, <586 4>,
> -				     <587 1>, <588 4>,
> -				     <589 1>, <590 4>,
> -				     <591 1>, <592 4>,
> -				     <593 1>, <594 4>,
> -				     <595 1>, <596 4>,
> -				     <597 1>, <598 4>,
> -				     <599 1>, <600 4>,
> -				     <601 1>, <602 4>,
> -				     <603 1>, <604 4>,
> -				     <605 1>, <606 4>,
> -				     <607 1>, <608 4>;
> -		};
>  
>  	};
>  };
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index aeff08ccbadd..e38a71d96201 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -1,19 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
> -config CRYPTO_DEV_HISI_SEC
> -	tristate "Support for Hisilicon SEC crypto block cipher accelerator"
> -	select CRYPTO_SKCIPHER
> -	select CRYPTO_ALGAPI
> -	select CRYPTO_LIB_DES
> -	select SG_SPLIT
> -	depends on ARM64 || COMPILE_TEST
> -	depends on HAS_IOMEM
> -	help
> -	  Support for Hisilicon SEC Engine in Hip06 and Hip07
> -
> -	  To compile this as a module, choose M here: the module
> -	  will be called hisi_sec.
> -
>  config CRYPTO_DEV_HISI_SEC2
>  	tristate "Support for HiSilicon SEC2 crypto block cipher accelerator"
>  	select CRYPTO_SKCIPHER
> diff --git a/drivers/crypto/hisilicon/Makefile b/drivers/crypto/hisilicon/Makefile
> index e1068ee9f973..a62965be8633 100644
> --- a/drivers/crypto/hisilicon/Makefile
> +++ b/drivers/crypto/hisilicon/Makefile
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_CRYPTO_DEV_HISI_HPRE) += hpre/
> -obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += sec/
>  obj-$(CONFIG_CRYPTO_DEV_HISI_SEC2) += sec2/
>  obj-$(CONFIG_CRYPTO_DEV_HISI_QM) += hisi_qm.o
>  hisi_qm-objs = qm.o sgl.o debugfs.o
> diff --git a/drivers/crypto/hisilicon/sec/Makefile b/drivers/crypto/hisilicon/sec/Makefile
> deleted file mode 100644
> index a55b698e0c27..000000000000
> --- a/drivers/crypto/hisilicon/sec/Makefile
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0
> -obj-$(CONFIG_CRYPTO_DEV_HISI_SEC) += hisi_sec.o
> -hisi_sec-y = sec_algs.o sec_drv.o
> diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
> deleted file mode 100644
> index 85eecbb40e7e..000000000000
> --- a/drivers/crypto/hisilicon/sec/sec_algs.c
> +++ /dev/null
> @@ -1,1122 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright (c) 2016-2017 HiSilicon Limited. */
> -#include <linux/crypto.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/dmapool.h>
> -#include <linux/module.h>
> -#include <linux/mutex.h>
> -#include <linux/slab.h>
> -
> -#include <crypto/aes.h>
> -#include <crypto/algapi.h>
> -#include <crypto/internal/des.h>
> -#include <crypto/skcipher.h>
> -#include <crypto/xts.h>
> -#include <crypto/internal/skcipher.h>
> -
> -#include "sec_drv.h"
> -
> -#define SEC_MAX_CIPHER_KEY		64
> -#define SEC_REQ_LIMIT SZ_32M
> -
> -struct sec_c_alg_cfg {
> -	unsigned c_alg		: 3;
> -	unsigned c_mode		: 3;
> -	unsigned key_len	: 2;
> -	unsigned c_width	: 2;
> -};
> -
> -static const struct sec_c_alg_cfg sec_c_alg_cfgs[] =  {
> -	[SEC_C_DES_ECB_64] = {
> -		.c_alg = SEC_C_ALG_DES,
> -		.c_mode = SEC_C_MODE_ECB,
> -		.key_len = SEC_KEY_LEN_DES,
> -	},
> -	[SEC_C_DES_CBC_64] = {
> -		.c_alg = SEC_C_ALG_DES,
> -		.c_mode = SEC_C_MODE_CBC,
> -		.key_len = SEC_KEY_LEN_DES,
> -	},
> -	[SEC_C_3DES_ECB_192_3KEY] = {
> -		.c_alg = SEC_C_ALG_3DES,
> -		.c_mode = SEC_C_MODE_ECB,
> -		.key_len = SEC_KEY_LEN_3DES_3_KEY,
> -	},
> -	[SEC_C_3DES_ECB_192_2KEY] = {
> -		.c_alg = SEC_C_ALG_3DES,
> -		.c_mode = SEC_C_MODE_ECB,
> -		.key_len = SEC_KEY_LEN_3DES_2_KEY,
> -	},
> -	[SEC_C_3DES_CBC_192_3KEY] = {
> -		.c_alg = SEC_C_ALG_3DES,
> -		.c_mode = SEC_C_MODE_CBC,
> -		.key_len = SEC_KEY_LEN_3DES_3_KEY,
> -	},
> -	[SEC_C_3DES_CBC_192_2KEY] = {
> -		.c_alg = SEC_C_ALG_3DES,
> -		.c_mode = SEC_C_MODE_CBC,
> -		.key_len = SEC_KEY_LEN_3DES_2_KEY,
> -	},
> -	[SEC_C_AES_ECB_128] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_ECB,
> -		.key_len = SEC_KEY_LEN_AES_128,
> -	},
> -	[SEC_C_AES_ECB_192] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_ECB,
> -		.key_len = SEC_KEY_LEN_AES_192,
> -	},
> -	[SEC_C_AES_ECB_256] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_ECB,
> -		.key_len = SEC_KEY_LEN_AES_256,
> -	},
> -	[SEC_C_AES_CBC_128] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_CBC,
> -		.key_len = SEC_KEY_LEN_AES_128,
> -	},
> -	[SEC_C_AES_CBC_192] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_CBC,
> -		.key_len = SEC_KEY_LEN_AES_192,
> -	},
> -	[SEC_C_AES_CBC_256] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_CBC,
> -		.key_len = SEC_KEY_LEN_AES_256,
> -	},
> -	[SEC_C_AES_CTR_128] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_CTR,
> -		.key_len = SEC_KEY_LEN_AES_128,
> -	},
> -	[SEC_C_AES_CTR_192] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_CTR,
> -		.key_len = SEC_KEY_LEN_AES_192,
> -	},
> -	[SEC_C_AES_CTR_256] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_CTR,
> -		.key_len = SEC_KEY_LEN_AES_256,
> -	},
> -	[SEC_C_AES_XTS_128] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_XTS,
> -		.key_len = SEC_KEY_LEN_AES_128,
> -	},
> -	[SEC_C_AES_XTS_256] = {
> -		.c_alg = SEC_C_ALG_AES,
> -		.c_mode = SEC_C_MODE_XTS,
> -		.key_len = SEC_KEY_LEN_AES_256,
> -	},
> -	[SEC_C_NULL] = {
> -	},
> -};
> -
> -/*
> - * Mutex used to ensure safe operation of reference count of
> - * alg providers
> - */
> -static DEFINE_MUTEX(algs_lock);
> -static unsigned int active_devs;
> -
> -static void sec_alg_skcipher_init_template(struct sec_alg_tfm_ctx *ctx,
> -					   struct sec_bd_info *req,
> -					   enum sec_cipher_alg alg)
> -{
> -	const struct sec_c_alg_cfg *cfg = &sec_c_alg_cfgs[alg];
> -
> -	memset(req, 0, sizeof(*req));
> -	req->w0 |= cfg->c_mode << SEC_BD_W0_C_MODE_S;
> -	req->w1 |= cfg->c_alg << SEC_BD_W1_C_ALG_S;
> -	req->w3 |= cfg->key_len << SEC_BD_W3_C_KEY_LEN_S;
> -	req->w0 |= cfg->c_width << SEC_BD_W0_C_WIDTH_S;
> -
> -	req->cipher_key_addr_lo = lower_32_bits(ctx->pkey);
> -	req->cipher_key_addr_hi = upper_32_bits(ctx->pkey);
> -}
> -
> -static void sec_alg_skcipher_init_context(struct crypto_skcipher *atfm,
> -					  const u8 *key,
> -					  unsigned int keylen,
> -					  enum sec_cipher_alg alg)
> -{
> -	struct crypto_tfm *tfm = crypto_skcipher_tfm(atfm);
> -	struct sec_alg_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -	ctx->cipher_alg = alg;
> -	memcpy(ctx->key, key, keylen);
> -	sec_alg_skcipher_init_template(ctx, &ctx->req_template,
> -				       ctx->cipher_alg);
> -}
> -
> -static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
> -			    dma_addr_t psec_sgl, struct sec_dev_info *info)
> -{
> -	struct sec_hw_sgl *sgl_current, *sgl_next;
> -	dma_addr_t sgl_next_dma;
> -
> -	sgl_current = hw_sgl;
> -	while (sgl_current) {
> -		sgl_next = sgl_current->next;
> -		sgl_next_dma = sgl_current->next_sgl;
> -
> -		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
> -
> -		sgl_current = sgl_next;
> -		psec_sgl = sgl_next_dma;
> -	}
> -}
> -
> -static int sec_alloc_and_fill_hw_sgl(struct sec_hw_sgl **sec_sgl,
> -				     dma_addr_t *psec_sgl,
> -				     struct scatterlist *sgl,
> -				     int count,
> -				     struct sec_dev_info *info,
> -				     gfp_t gfp)
> -{
> -	struct sec_hw_sgl *sgl_current = NULL;
> -	struct sec_hw_sgl *sgl_next;
> -	dma_addr_t sgl_next_dma;
> -	struct scatterlist *sg;
> -	int ret, sge_index, i;
> -
> -	if (!count)
> -		return -EINVAL;
> -
> -	for_each_sg(sgl, sg, count, i) {
> -		sge_index = i % SEC_MAX_SGE_NUM;
> -		if (sge_index == 0) {
> -			sgl_next = dma_pool_zalloc(info->hw_sgl_pool,
> -						   gfp, &sgl_next_dma);
> -			if (!sgl_next) {
> -				ret = -ENOMEM;
> -				goto err_free_hw_sgls;
> -			}
> -
> -			if (!sgl_current) { /* First one */
> -				*psec_sgl = sgl_next_dma;
> -				*sec_sgl = sgl_next;
> -			} else { /* Chained */
> -				sgl_current->entry_sum_in_sgl = SEC_MAX_SGE_NUM;
> -				sgl_current->next_sgl = sgl_next_dma;
> -				sgl_current->next = sgl_next;
> -			}
> -			sgl_current = sgl_next;
> -		}
> -		sgl_current->sge_entries[sge_index].buf = sg_dma_address(sg);
> -		sgl_current->sge_entries[sge_index].len = sg_dma_len(sg);
> -		sgl_current->data_bytes_in_sgl += sg_dma_len(sg);
> -	}
> -	sgl_current->entry_sum_in_sgl = count % SEC_MAX_SGE_NUM;
> -	sgl_current->next_sgl = 0;
> -	(*sec_sgl)->entry_sum_in_chain = count;
> -
> -	return 0;
> -
> -err_free_hw_sgls:
> -	sec_free_hw_sgl(*sec_sgl, *psec_sgl, info);
> -	*psec_sgl = 0;
> -
> -	return ret;
> -}
> -
> -static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
> -				   const u8 *key, unsigned int keylen,
> -				   enum sec_cipher_alg alg)
> -{
> -	struct sec_alg_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	struct device *dev = ctx->queue->dev_info->dev;
> -
> -	mutex_lock(&ctx->lock);
> -	if (ctx->key) {
> -		/* rekeying */
> -		memset(ctx->key, 0, SEC_MAX_CIPHER_KEY);
> -	} else {
> -		/* new key */
> -		ctx->key = dma_alloc_coherent(dev, SEC_MAX_CIPHER_KEY,
> -					      &ctx->pkey, GFP_KERNEL);
> -		if (!ctx->key) {
> -			mutex_unlock(&ctx->lock);
> -			return -ENOMEM;
> -		}
> -	}
> -	mutex_unlock(&ctx->lock);
> -	sec_alg_skcipher_init_context(tfm, key, keylen, alg);
> -
> -	return 0;
> -}
> -
> -static int sec_alg_skcipher_setkey_aes_ecb(struct crypto_skcipher *tfm,
> -					   const u8 *key, unsigned int keylen)
> -{
> -	enum sec_cipher_alg alg;
> -
> -	switch (keylen) {
> -	case AES_KEYSIZE_128:
> -		alg = SEC_C_AES_ECB_128;
> -		break;
> -	case AES_KEYSIZE_192:
> -		alg = SEC_C_AES_ECB_192;
> -		break;
> -	case AES_KEYSIZE_256:
> -		alg = SEC_C_AES_ECB_256;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
> -}
> -
> -static int sec_alg_skcipher_setkey_aes_cbc(struct crypto_skcipher *tfm,
> -					   const u8 *key, unsigned int keylen)
> -{
> -	enum sec_cipher_alg alg;
> -
> -	switch (keylen) {
> -	case AES_KEYSIZE_128:
> -		alg = SEC_C_AES_CBC_128;
> -		break;
> -	case AES_KEYSIZE_192:
> -		alg = SEC_C_AES_CBC_192;
> -		break;
> -	case AES_KEYSIZE_256:
> -		alg = SEC_C_AES_CBC_256;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
> -}
> -
> -static int sec_alg_skcipher_setkey_aes_ctr(struct crypto_skcipher *tfm,
> -					   const u8 *key, unsigned int keylen)
> -{
> -	enum sec_cipher_alg alg;
> -
> -	switch (keylen) {
> -	case AES_KEYSIZE_128:
> -		alg = SEC_C_AES_CTR_128;
> -		break;
> -	case AES_KEYSIZE_192:
> -		alg = SEC_C_AES_CTR_192;
> -		break;
> -	case AES_KEYSIZE_256:
> -		alg = SEC_C_AES_CTR_256;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
> -}
> -
> -static int sec_alg_skcipher_setkey_aes_xts(struct crypto_skcipher *tfm,
> -					   const u8 *key, unsigned int keylen)
> -{
> -	enum sec_cipher_alg alg;
> -	int ret;
> -
> -	ret = xts_verify_key(tfm, key, keylen);
> -	if (ret)
> -		return ret;
> -
> -	switch (keylen) {
> -	case AES_KEYSIZE_128 * 2:
> -		alg = SEC_C_AES_XTS_128;
> -		break;
> -	case AES_KEYSIZE_256 * 2:
> -		alg = SEC_C_AES_XTS_256;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return sec_alg_skcipher_setkey(tfm, key, keylen, alg);
> -}
> -
> -static int sec_alg_skcipher_setkey_des_ecb(struct crypto_skcipher *tfm,
> -					   const u8 *key, unsigned int keylen)
> -{
> -	return verify_skcipher_des_key(tfm, key) ?:
> -	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
> -}
> -
> -static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
> -					   const u8 *key, unsigned int keylen)
> -{
> -	return verify_skcipher_des_key(tfm, key) ?:
> -	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
> -}
> -
> -static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
> -					    const u8 *key, unsigned int keylen)
> -{
> -	return verify_skcipher_des3_key(tfm, key) ?:
> -	       sec_alg_skcipher_setkey(tfm, key, keylen,
> -				       SEC_C_3DES_ECB_192_3KEY);
> -}
> -
> -static int sec_alg_skcipher_setkey_3des_cbc(struct crypto_skcipher *tfm,
> -					    const u8 *key, unsigned int keylen)
> -{
> -	return verify_skcipher_des3_key(tfm, key) ?:
> -	       sec_alg_skcipher_setkey(tfm, key, keylen,
> -				       SEC_C_3DES_CBC_192_3KEY);
> -}
> -
> -static void sec_alg_free_el(struct sec_request_el *el,
> -			    struct sec_dev_info *info)
> -{
> -	sec_free_hw_sgl(el->out, el->dma_out, info);
> -	sec_free_hw_sgl(el->in, el->dma_in, info);
> -	kfree(el->sgl_in);
> -	kfree(el->sgl_out);
> -	kfree(el);
> -}
> -
> -/* queuelock must be held */
> -static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue)
> -{
> -	struct sec_request_el *el, *temp;
> -	int ret = 0;
> -
> -	mutex_lock(&sec_req->lock);
> -	list_for_each_entry_safe(el, temp, &sec_req->elements, head) {
> -		/*
> -		 * Add to hardware queue only under following circumstances
> -		 * 1) Software and hardware queue empty so no chain dependencies
> -		 * 2) No dependencies as new IV - (check software queue empty
> -		 *    to maintain order)
> -		 * 3) No dependencies because the mode does no chaining.
> -		 *
> -		 * In other cases first insert onto the software queue which
> -		 * is then emptied as requests complete
> -		 */
> -		if (!queue->havesoftqueue ||
> -		    (kfifo_is_empty(&queue->softqueue) &&
> -		     sec_queue_empty(queue))) {
> -			ret = sec_queue_send(queue, &el->req, sec_req);
> -			if (ret == -EAGAIN) {
> -				/* Wait unti we can send then try again */
> -				/* DEAD if here - should not happen */
> -				ret = -EBUSY;
> -				goto err_unlock;
> -			}
> -		} else {
> -			kfifo_put(&queue->softqueue, el);
> -		}
> -	}
> -err_unlock:
> -	mutex_unlock(&sec_req->lock);
> -
> -	return ret;
> -}
> -
> -static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
> -				      struct crypto_async_request *req_base)
> -{
> -	struct skcipher_request *skreq = container_of(req_base,
> -						      struct skcipher_request,
> -						      base);
> -	struct sec_request *sec_req = skcipher_request_ctx(skreq);
> -	struct sec_request *backlog_req;
> -	struct sec_request_el *sec_req_el, *nextrequest;
> -	struct sec_alg_tfm_ctx *ctx = sec_req->tfm_ctx;
> -	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(skreq);
> -	struct device *dev = ctx->queue->dev_info->dev;
> -	int icv_or_skey_en, ret;
> -	bool done;
> -
> -	sec_req_el = list_first_entry(&sec_req->elements, struct sec_request_el,
> -				      head);
> -	icv_or_skey_en = (sec_resp->w0 & SEC_BD_W0_ICV_OR_SKEY_EN_M) >>
> -		SEC_BD_W0_ICV_OR_SKEY_EN_S;
> -	if (sec_resp->w1 & SEC_BD_W1_BD_INVALID || icv_or_skey_en == 3) {
> -		dev_err(dev, "Got an invalid answer %lu %d\n",
> -			sec_resp->w1 & SEC_BD_W1_BD_INVALID,
> -			icv_or_skey_en);
> -		sec_req->err = -EINVAL;
> -		/*
> -		 * We need to muddle on to avoid getting stuck with elements
> -		 * on the queue. Error will be reported so requester so
> -		 * it should be able to handle appropriately.
> -		 */
> -	}
> -
> -	spin_lock_bh(&ctx->queue->queuelock);
> -	/* Put the IV in place for chained cases */
> -	switch (ctx->cipher_alg) {
> -	case SEC_C_AES_CBC_128:
> -	case SEC_C_AES_CBC_192:
> -	case SEC_C_AES_CBC_256:
> -		if (sec_req_el->req.w0 & SEC_BD_W0_DE)
> -			sg_pcopy_to_buffer(sec_req_el->sgl_out,
> -					   sg_nents(sec_req_el->sgl_out),
> -					   skreq->iv,
> -					   crypto_skcipher_ivsize(atfm),
> -					   sec_req_el->el_length -
> -					   crypto_skcipher_ivsize(atfm));
> -		else
> -			sg_pcopy_to_buffer(sec_req_el->sgl_in,
> -					   sg_nents(sec_req_el->sgl_in),
> -					   skreq->iv,
> -					   crypto_skcipher_ivsize(atfm),
> -					   sec_req_el->el_length -
> -					   crypto_skcipher_ivsize(atfm));
> -		/* No need to sync to the device as coherent DMA */
> -		break;
> -	case SEC_C_AES_CTR_128:
> -	case SEC_C_AES_CTR_192:
> -	case SEC_C_AES_CTR_256:
> -		crypto_inc(skreq->iv, 16);
> -		break;
> -	default:
> -		/* Do not update */
> -		break;
> -	}
> -
> -	if (ctx->queue->havesoftqueue &&
> -	    !kfifo_is_empty(&ctx->queue->softqueue) &&
> -	    sec_queue_empty(ctx->queue)) {
> -		ret = kfifo_get(&ctx->queue->softqueue, &nextrequest);
> -		if (ret <= 0)
> -			dev_err(dev,
> -				"Error getting next element from kfifo %d\n",
> -				ret);
> -		else
> -			/* We know there is space so this cannot fail */
> -			sec_queue_send(ctx->queue, &nextrequest->req,
> -				       nextrequest->sec_req);
> -	} else if (!list_empty(&ctx->backlog)) {
> -		/* Need to verify there is room first */
> -		backlog_req = list_first_entry(&ctx->backlog,
> -					       typeof(*backlog_req),
> -					       backlog_head);
> -		if (sec_queue_can_enqueue(ctx->queue,
> -		    backlog_req->num_elements) ||
> -		    (ctx->queue->havesoftqueue &&
> -		     kfifo_avail(&ctx->queue->softqueue) >
> -		     backlog_req->num_elements)) {
> -			sec_send_request(backlog_req, ctx->queue);
> -			crypto_request_complete(backlog_req->req_base,
> -						-EINPROGRESS);
> -			list_del(&backlog_req->backlog_head);
> -		}
> -	}
> -	spin_unlock_bh(&ctx->queue->queuelock);
> -
> -	mutex_lock(&sec_req->lock);
> -	list_del(&sec_req_el->head);
> -	mutex_unlock(&sec_req->lock);
> -	sec_alg_free_el(sec_req_el, ctx->queue->dev_info);
> -
> -	/*
> -	 * Request is done.
> -	 * The dance is needed as the lock is freed in the completion
> -	 */
> -	mutex_lock(&sec_req->lock);
> -	done = list_empty(&sec_req->elements);
> -	mutex_unlock(&sec_req->lock);
> -	if (done) {
> -		if (crypto_skcipher_ivsize(atfm)) {
> -			dma_unmap_single(dev, sec_req->dma_iv,
> -					 crypto_skcipher_ivsize(atfm),
> -					 DMA_TO_DEVICE);
> -		}
> -		dma_unmap_sg(dev, skreq->src, sec_req->len_in,
> -			     DMA_BIDIRECTIONAL);
> -		if (skreq->src != skreq->dst)
> -			dma_unmap_sg(dev, skreq->dst, sec_req->len_out,
> -				     DMA_BIDIRECTIONAL);
> -		skcipher_request_complete(skreq, sec_req->err);
> -	}
> -}
> -
> -void sec_alg_callback(struct sec_bd_info *resp, void *shadow)
> -{
> -	struct sec_request *sec_req = shadow;
> -
> -	sec_req->cb(resp, sec_req->req_base);
> -}
> -
> -static int sec_alg_alloc_and_calc_split_sizes(int length, size_t **split_sizes,
> -					      int *steps, gfp_t gfp)
> -{
> -	size_t *sizes;
> -	int i;
> -
> -	/* Split into suitable sized blocks */
> -	*steps = roundup(length, SEC_REQ_LIMIT) / SEC_REQ_LIMIT;
> -	sizes = kzalloc_objs(*sizes, *steps, gfp);
> -	if (!sizes)
> -		return -ENOMEM;
> -
> -	for (i = 0; i < *steps - 1; i++)
> -		sizes[i] = SEC_REQ_LIMIT;
> -	sizes[*steps - 1] = length - SEC_REQ_LIMIT * (*steps - 1);
> -	*split_sizes = sizes;
> -
> -	return 0;
> -}
> -
> -static int sec_map_and_split_sg(struct scatterlist *sgl, size_t *split_sizes,
> -				int steps, struct scatterlist ***splits,
> -				int **splits_nents,
> -				int sgl_len_in,
> -				struct device *dev, gfp_t gfp)
> -{
> -	int ret, count;
> -
> -	count = dma_map_sg(dev, sgl, sgl_len_in, DMA_BIDIRECTIONAL);
> -	if (!count)
> -		return -EINVAL;
> -
> -	*splits = kzalloc_objs(struct scatterlist *, steps, gfp);
> -	if (!*splits) {
> -		ret = -ENOMEM;
> -		goto err_unmap_sg;
> -	}
> -	*splits_nents = kzalloc_objs(int, steps, gfp);
> -	if (!*splits_nents) {
> -		ret = -ENOMEM;
> -		goto err_free_splits;
> -	}
> -
> -	/* output the scatter list before and after this */
> -	ret = sg_split(sgl, count, 0, steps, split_sizes,
> -		       *splits, *splits_nents, gfp);
> -	if (ret) {
> -		ret = -ENOMEM;
> -		goto err_free_splits_nents;
> -	}
> -
> -	return 0;
> -
> -err_free_splits_nents:
> -	kfree(*splits_nents);
> -err_free_splits:
> -	kfree(*splits);
> -err_unmap_sg:
> -	dma_unmap_sg(dev, sgl, sgl_len_in, DMA_BIDIRECTIONAL);
> -
> -	return ret;
> -}
> -
> -/*
> - * Reverses the sec_map_and_split_sg call for messages not yet added to
> - * the queues.
> - */
> -static void sec_unmap_sg_on_err(struct scatterlist *sgl, int steps,
> -				struct scatterlist **splits, int *splits_nents,
> -				int sgl_len_in, struct device *dev)
> -{
> -	int i;
> -
> -	for (i = 0; i < steps; i++)
> -		kfree(splits[i]);
> -	kfree(splits_nents);
> -	kfree(splits);
> -
> -	dma_unmap_sg(dev, sgl, sgl_len_in, DMA_BIDIRECTIONAL);
> -}
> -
> -static struct sec_request_el
> -*sec_alg_alloc_and_fill_el(struct sec_bd_info *template, int encrypt,
> -			   int el_size, bool different_dest,
> -			   struct scatterlist *sgl_in, int n_ents_in,
> -			   struct scatterlist *sgl_out, int n_ents_out,
> -			   struct sec_dev_info *info, gfp_t gfp)
> -{
> -	struct sec_request_el *el;
> -	struct sec_bd_info *req;
> -	int ret;
> -
> -	el = kzalloc_obj(*el, gfp);
> -	if (!el)
> -		return ERR_PTR(-ENOMEM);
> -	el->el_length = el_size;
> -	req = &el->req;
> -	memcpy(req, template, sizeof(*req));
> -
> -	req->w0 &= ~SEC_BD_W0_CIPHER_M;
> -	if (encrypt)
> -		req->w0 |= SEC_CIPHER_ENCRYPT << SEC_BD_W0_CIPHER_S;
> -	else
> -		req->w0 |= SEC_CIPHER_DECRYPT << SEC_BD_W0_CIPHER_S;
> -
> -	req->w0 &= ~SEC_BD_W0_C_GRAN_SIZE_19_16_M;
> -	req->w0 |= ((el_size >> 16) << SEC_BD_W0_C_GRAN_SIZE_19_16_S) &
> -		SEC_BD_W0_C_GRAN_SIZE_19_16_M;
> -
> -	req->w0 &= ~SEC_BD_W0_C_GRAN_SIZE_21_20_M;
> -	req->w0 |= ((el_size >> 20) << SEC_BD_W0_C_GRAN_SIZE_21_20_S) &
> -		SEC_BD_W0_C_GRAN_SIZE_21_20_M;
> -
> -	/* Writing whole u32 so no need to take care of masking */
> -	req->w2 = ((1 << SEC_BD_W2_GRAN_NUM_S) & SEC_BD_W2_GRAN_NUM_M) |
> -		((el_size << SEC_BD_W2_C_GRAN_SIZE_15_0_S) &
> -		 SEC_BD_W2_C_GRAN_SIZE_15_0_M);
> -
> -	req->w3 &= ~SEC_BD_W3_CIPHER_LEN_OFFSET_M;
> -	req->w1 |= SEC_BD_W1_ADDR_TYPE;
> -
> -	el->sgl_in = sgl_in;
> -
> -	ret = sec_alloc_and_fill_hw_sgl(&el->in, &el->dma_in, el->sgl_in,
> -					n_ents_in, info, gfp);
> -	if (ret)
> -		goto err_free_el;
> -
> -	req->data_addr_lo = lower_32_bits(el->dma_in);
> -	req->data_addr_hi = upper_32_bits(el->dma_in);
> -
> -	if (different_dest) {
> -		el->sgl_out = sgl_out;
> -		ret = sec_alloc_and_fill_hw_sgl(&el->out, &el->dma_out,
> -						el->sgl_out,
> -						n_ents_out, info, gfp);
> -		if (ret)
> -			goto err_free_hw_sgl_in;
> -
> -		req->w0 |= SEC_BD_W0_DE;
> -		req->cipher_destin_addr_lo = lower_32_bits(el->dma_out);
> -		req->cipher_destin_addr_hi = upper_32_bits(el->dma_out);
> -
> -	} else {
> -		req->w0 &= ~SEC_BD_W0_DE;
> -		req->cipher_destin_addr_lo = lower_32_bits(el->dma_in);
> -		req->cipher_destin_addr_hi = upper_32_bits(el->dma_in);
> -	}
> -
> -	return el;
> -
> -err_free_hw_sgl_in:
> -	sec_free_hw_sgl(el->in, el->dma_in, info);
> -err_free_el:
> -	kfree(el);
> -
> -	return ERR_PTR(ret);
> -}
> -
> -static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
> -				   bool encrypt)
> -{
> -	struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(skreq);
> -	struct crypto_tfm *tfm = crypto_skcipher_tfm(atfm);
> -	struct sec_alg_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> -	struct sec_queue *queue = ctx->queue;
> -	struct sec_request *sec_req = skcipher_request_ctx(skreq);
> -	struct sec_dev_info *info = queue->dev_info;
> -	int i, ret, steps;
> -	size_t *split_sizes;
> -	struct scatterlist **splits_in;
> -	struct scatterlist **splits_out = NULL;
> -	int *splits_in_nents;
> -	int *splits_out_nents = NULL;
> -	struct sec_request_el *el, *temp;
> -	bool split = skreq->src != skreq->dst;
> -	gfp_t gfp = skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
> -
> -	mutex_init(&sec_req->lock);
> -	sec_req->req_base = &skreq->base;
> -	sec_req->err = 0;
> -	/* SGL mapping out here to allow us to break it up as necessary */
> -	sec_req->len_in = sg_nents(skreq->src);
> -
> -	ret = sec_alg_alloc_and_calc_split_sizes(skreq->cryptlen, &split_sizes,
> -						 &steps, gfp);
> -	if (ret)
> -		return ret;
> -	sec_req->num_elements = steps;
> -	ret = sec_map_and_split_sg(skreq->src, split_sizes, steps, &splits_in,
> -				   &splits_in_nents, sec_req->len_in,
> -				   info->dev, gfp);
> -	if (ret)
> -		goto err_free_split_sizes;
> -
> -	if (split) {
> -		sec_req->len_out = sg_nents(skreq->dst);
> -		ret = sec_map_and_split_sg(skreq->dst, split_sizes, steps,
> -					   &splits_out, &splits_out_nents,
> -					   sec_req->len_out, info->dev, gfp);
> -		if (ret)
> -			goto err_unmap_in_sg;
> -	}
> -	/* Shared info stored in seq_req - applies to all BDs */
> -	sec_req->tfm_ctx = ctx;
> -	sec_req->cb = sec_skcipher_alg_callback;
> -	INIT_LIST_HEAD(&sec_req->elements);
> -
> -	/*
> -	 * Future optimization.
> -	 * In the chaining case we can't use a dma pool bounce buffer
> -	 * but in the case where we know there is no chaining we can
> -	 */
> -	if (crypto_skcipher_ivsize(atfm)) {
> -		sec_req->dma_iv = dma_map_single(info->dev, skreq->iv,
> -						 crypto_skcipher_ivsize(atfm),
> -						 DMA_TO_DEVICE);
> -		if (dma_mapping_error(info->dev, sec_req->dma_iv)) {
> -			ret = -ENOMEM;
> -			goto err_unmap_out_sg;
> -		}
> -	}
> -
> -	/* Set them all up then queue - cleaner error handling. */
> -	for (i = 0; i < steps; i++) {
> -		el = sec_alg_alloc_and_fill_el(&ctx->req_template,
> -					       encrypt ? 1 : 0,
> -					       split_sizes[i],
> -					       skreq->src != skreq->dst,
> -					       splits_in[i], splits_in_nents[i],
> -					       split ? splits_out[i] : NULL,
> -					       split ? splits_out_nents[i] : 0,
> -					       info, gfp);
> -		if (IS_ERR(el)) {
> -			ret = PTR_ERR(el);
> -			goto err_free_elements;
> -		}
> -		el->req.cipher_iv_addr_lo = lower_32_bits(sec_req->dma_iv);
> -		el->req.cipher_iv_addr_hi = upper_32_bits(sec_req->dma_iv);
> -		el->sec_req = sec_req;
> -		list_add_tail(&el->head, &sec_req->elements);
> -	}
> -
> -	/*
> -	 * Only attempt to queue if the whole lot can fit in the queue -
> -	 * we can't successfully cleanup after a partial queing so this
> -	 * must succeed or fail atomically.
> -	 *
> -	 * Big hammer test of both software and hardware queues - could be
> -	 * more refined but this is unlikely to happen so no need.
> -	 */
> -
> -	/* Grab a big lock for a long time to avoid concurrency issues */
> -	spin_lock_bh(&queue->queuelock);
> -
> -	/*
> -	 * Can go on to queue if we have space in either:
> -	 * 1) The hardware queue and no software queue
> -	 * 2) The software queue
> -	 * AND there is nothing in the backlog.  If there is backlog we
> -	 * have to only queue to the backlog queue and return busy.
> -	 */
> -	if ((!sec_queue_can_enqueue(queue, steps) &&
> -	     (!queue->havesoftqueue ||
> -	      kfifo_avail(&queue->softqueue) > steps)) ||
> -	    !list_empty(&ctx->backlog)) {
> -		ret = -EBUSY;
> -		if ((skreq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
> -			list_add_tail(&sec_req->backlog_head, &ctx->backlog);
> -			spin_unlock_bh(&queue->queuelock);
> -			goto out;
> -		}
> -
> -		spin_unlock_bh(&queue->queuelock);
> -		goto err_free_elements;
> -	}
> -	ret = sec_send_request(sec_req, queue);
> -	spin_unlock_bh(&queue->queuelock);
> -	if (ret)
> -		goto err_free_elements;
> -
> -	ret = -EINPROGRESS;
> -out:
> -	/* Cleanup - all elements in pointer arrays have been copied */
> -	kfree(splits_in_nents);
> -	kfree(splits_in);
> -	kfree(splits_out_nents);
> -	kfree(splits_out);
> -	kfree(split_sizes);
> -	return ret;
> -
> -err_free_elements:
> -	list_for_each_entry_safe(el, temp, &sec_req->elements, head) {
> -		list_del(&el->head);
> -		sec_alg_free_el(el, info);
> -	}
> -	if (crypto_skcipher_ivsize(atfm))
> -		dma_unmap_single(info->dev, sec_req->dma_iv,
> -				 crypto_skcipher_ivsize(atfm),
> -				 DMA_TO_DEVICE);
> -err_unmap_out_sg:
> -	if (split)
> -		sec_unmap_sg_on_err(skreq->dst, steps, splits_out,
> -				    splits_out_nents, sec_req->len_out,
> -				    info->dev);
> -err_unmap_in_sg:
> -	sec_unmap_sg_on_err(skreq->src, steps, splits_in, splits_in_nents,
> -			    sec_req->len_in, info->dev);
> -err_free_split_sizes:
> -	kfree(split_sizes);
> -
> -	return ret;
> -}
> -
> -static int sec_alg_skcipher_encrypt(struct skcipher_request *req)
> -{
> -	return sec_alg_skcipher_crypto(req, true);
> -}
> -
> -static int sec_alg_skcipher_decrypt(struct skcipher_request *req)
> -{
> -	return sec_alg_skcipher_crypto(req, false);
> -}
> -
> -static int sec_alg_skcipher_init(struct crypto_skcipher *tfm)
> -{
> -	struct sec_alg_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> -
> -	mutex_init(&ctx->lock);
> -	INIT_LIST_HEAD(&ctx->backlog);
> -	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_request));
> -
> -	ctx->queue = sec_queue_alloc_start_safe();
> -	if (IS_ERR(ctx->queue))
> -		return PTR_ERR(ctx->queue);
> -
> -	spin_lock_init(&ctx->queue->queuelock);
> -	ctx->queue->havesoftqueue = false;
> -
> -	return 0;
> -}
> -
> -static void sec_alg_skcipher_exit(struct crypto_skcipher *tfm)
> -{
> -	struct sec_alg_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	struct device *dev = ctx->queue->dev_info->dev;
> -
> -	if (ctx->key) {
> -		memzero_explicit(ctx->key, SEC_MAX_CIPHER_KEY);
> -		dma_free_coherent(dev, SEC_MAX_CIPHER_KEY, ctx->key,
> -				  ctx->pkey);
> -	}
> -	sec_queue_stop_release(ctx->queue);
> -}
> -
> -static int sec_alg_skcipher_init_with_queue(struct crypto_skcipher *tfm)
> -{
> -	struct sec_alg_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	int ret;
> -
> -	ret = sec_alg_skcipher_init(tfm);
> -	if (ret)
> -		return ret;
> -
> -	INIT_KFIFO(ctx->queue->softqueue);
> -	ret = kfifo_alloc(&ctx->queue->softqueue, 512, GFP_KERNEL);
> -	if (ret) {
> -		sec_alg_skcipher_exit(tfm);
> -		return ret;
> -	}
> -	ctx->queue->havesoftqueue = true;
> -
> -	return 0;
> -}
> -
> -static void sec_alg_skcipher_exit_with_queue(struct crypto_skcipher *tfm)
> -{
> -	struct sec_alg_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> -
> -	kfifo_free(&ctx->queue->softqueue);
> -	sec_alg_skcipher_exit(tfm);
> -}
> -
> -static struct skcipher_alg sec_algs[] = {
> -	{
> -		.base = {
> -			.cra_name = "ecb(aes)",
> -			.cra_driver_name = "hisi_sec_aes_ecb",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init,
> -		.exit = sec_alg_skcipher_exit,
> -		.setkey = sec_alg_skcipher_setkey_aes_ecb,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = AES_MIN_KEY_SIZE,
> -		.max_keysize = AES_MAX_KEY_SIZE,
> -		.ivsize = 0,
> -	}, {
> -		.base = {
> -			.cra_name = "cbc(aes)",
> -			.cra_driver_name = "hisi_sec_aes_cbc",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init_with_queue,
> -		.exit = sec_alg_skcipher_exit_with_queue,
> -		.setkey = sec_alg_skcipher_setkey_aes_cbc,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = AES_MIN_KEY_SIZE,
> -		.max_keysize = AES_MAX_KEY_SIZE,
> -		.ivsize = AES_BLOCK_SIZE,
> -	}, {
> -		.base = {
> -			.cra_name = "ctr(aes)",
> -			.cra_driver_name = "hisi_sec_aes_ctr",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init_with_queue,
> -		.exit = sec_alg_skcipher_exit_with_queue,
> -		.setkey = sec_alg_skcipher_setkey_aes_ctr,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = AES_MIN_KEY_SIZE,
> -		.max_keysize = AES_MAX_KEY_SIZE,
> -		.ivsize = AES_BLOCK_SIZE,
> -	}, {
> -		.base = {
> -			.cra_name = "xts(aes)",
> -			.cra_driver_name = "hisi_sec_aes_xts",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = AES_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init,
> -		.exit = sec_alg_skcipher_exit,
> -		.setkey = sec_alg_skcipher_setkey_aes_xts,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = 2 * AES_MIN_KEY_SIZE,
> -		.max_keysize = 2 * AES_MAX_KEY_SIZE,
> -		.ivsize = AES_BLOCK_SIZE,
> -	}, {
> -	/* Unable to find any test vectors so untested */
> -		.base = {
> -			.cra_name = "ecb(des)",
> -			.cra_driver_name = "hisi_sec_des_ecb",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = DES_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init,
> -		.exit = sec_alg_skcipher_exit,
> -		.setkey = sec_alg_skcipher_setkey_des_ecb,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = DES_KEY_SIZE,
> -		.max_keysize = DES_KEY_SIZE,
> -		.ivsize = 0,
> -	}, {
> -		.base = {
> -			.cra_name = "cbc(des)",
> -			.cra_driver_name = "hisi_sec_des_cbc",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = DES_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init_with_queue,
> -		.exit = sec_alg_skcipher_exit_with_queue,
> -		.setkey = sec_alg_skcipher_setkey_des_cbc,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = DES_KEY_SIZE,
> -		.max_keysize = DES_KEY_SIZE,
> -		.ivsize = DES_BLOCK_SIZE,
> -	}, {
> -		.base = {
> -			.cra_name = "cbc(des3_ede)",
> -			.cra_driver_name = "hisi_sec_3des_cbc",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init_with_queue,
> -		.exit = sec_alg_skcipher_exit_with_queue,
> -		.setkey = sec_alg_skcipher_setkey_3des_cbc,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = DES3_EDE_KEY_SIZE,
> -		.max_keysize = DES3_EDE_KEY_SIZE,
> -		.ivsize = DES3_EDE_BLOCK_SIZE,
> -	}, {
> -		.base = {
> -			.cra_name = "ecb(des3_ede)",
> -			.cra_driver_name = "hisi_sec_3des_ecb",
> -			.cra_priority = 4001,
> -			.cra_flags = CRYPTO_ALG_ASYNC |
> -				     CRYPTO_ALG_ALLOCATES_MEMORY,
> -			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
> -			.cra_alignmask = 0,
> -			.cra_module = THIS_MODULE,
> -		},
> -		.init = sec_alg_skcipher_init,
> -		.exit = sec_alg_skcipher_exit,
> -		.setkey = sec_alg_skcipher_setkey_3des_ecb,
> -		.decrypt = sec_alg_skcipher_decrypt,
> -		.encrypt = sec_alg_skcipher_encrypt,
> -		.min_keysize = DES3_EDE_KEY_SIZE,
> -		.max_keysize = DES3_EDE_KEY_SIZE,
> -		.ivsize = 0,
> -	}
> -};
> -
> -int sec_algs_register(void)
> -{
> -	int ret = 0;
> -
> -	mutex_lock(&algs_lock);
> -	if (++active_devs != 1)
> -		goto unlock;
> -
> -	ret = crypto_register_skciphers(sec_algs, ARRAY_SIZE(sec_algs));
> -	if (ret)
> -		--active_devs;
> -unlock:
> -	mutex_unlock(&algs_lock);
> -
> -	return ret;
> -}
> -
> -void sec_algs_unregister(void)
> -{
> -	mutex_lock(&algs_lock);
> -	if (--active_devs != 0)
> -		goto unlock;
> -	crypto_unregister_skciphers(sec_algs, ARRAY_SIZE(sec_algs));
> -
> -unlock:
> -	mutex_unlock(&algs_lock);
> -}
> diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
> deleted file mode 100644
> index 2514a5e1f9b4..000000000000
> --- a/drivers/crypto/hisilicon/sec/sec_drv.c
> +++ /dev/null
> @@ -1,1307 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Driver for the HiSilicon SEC units found on Hip06 Hip07
> - *
> - * Copyright (c) 2016-2017 HiSilicon Limited.
> - */
> -#include <linux/acpi.h>
> -#include <linux/atomic.h>
> -#include <linux/delay.h>
> -#include <linux/dma-direction.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/dmapool.h>
> -#include <linux/io.h>
> -#include <linux/iommu.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/irqreturn.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/of.h>
> -#include <linux/platform_device.h>
> -#include <linux/slab.h>
> -
> -#include "sec_drv.h"
> -
> -#define SEC_QUEUE_AR_FROCE_ALLOC			0
> -#define SEC_QUEUE_AR_FROCE_NOALLOC			1
> -#define SEC_QUEUE_AR_FROCE_DIS				2
> -
> -#define SEC_QUEUE_AW_FROCE_ALLOC			0
> -#define SEC_QUEUE_AW_FROCE_NOALLOC			1
> -#define SEC_QUEUE_AW_FROCE_DIS				2
> -
> -/* SEC_ALGSUB registers */
> -#define SEC_ALGSUB_CLK_EN_REG				0x03b8
> -#define SEC_ALGSUB_CLK_DIS_REG				0x03bc
> -#define SEC_ALGSUB_CLK_ST_REG				0x535c
> -#define SEC_ALGSUB_RST_REQ_REG				0x0aa8
> -#define SEC_ALGSUB_RST_DREQ_REG				0x0aac
> -#define SEC_ALGSUB_RST_ST_REG				0x5a54
> -#define   SEC_ALGSUB_RST_ST_IS_RST			BIT(0)
> -
> -#define SEC_ALGSUB_BUILD_RST_REQ_REG			0x0ab8
> -#define SEC_ALGSUB_BUILD_RST_DREQ_REG			0x0abc
> -#define SEC_ALGSUB_BUILD_RST_ST_REG			0x5a5c
> -#define   SEC_ALGSUB_BUILD_RST_ST_IS_RST		BIT(0)
> -
> -#define SEC_SAA_BASE					0x00001000UL
> -
> -/* SEC_SAA registers */
> -#define SEC_SAA_CTRL_REG(x)	((x) * SEC_SAA_ADDR_SIZE)
> -#define   SEC_SAA_CTRL_GET_QM_EN			BIT(0)
> -
> -#define SEC_ST_INTMSK1_REG				0x0200
> -#define SEC_ST_RINT1_REG				0x0400
> -#define SEC_ST_INTSTS1_REG				0x0600
> -#define SEC_BD_MNG_STAT_REG				0x0800
> -#define SEC_PARSING_STAT_REG				0x0804
> -#define SEC_LOAD_TIME_OUT_CNT_REG			0x0808
> -#define SEC_CORE_WORK_TIME_OUT_CNT_REG			0x080c
> -#define SEC_BACK_TIME_OUT_CNT_REG			0x0810
> -#define SEC_BD1_PARSING_RD_TIME_OUT_CNT_REG		0x0814
> -#define SEC_BD1_PARSING_WR_TIME_OUT_CNT_REG		0x0818
> -#define SEC_BD2_PARSING_RD_TIME_OUT_CNT_REG		0x081c
> -#define SEC_BD2_PARSING_WR_TIME_OUT_CNT_REG		0x0820
> -#define SEC_SAA_ACC_REG					0x083c
> -#define SEC_BD_NUM_CNT_IN_SEC_REG			0x0858
> -#define SEC_LOAD_WORK_TIME_CNT_REG			0x0860
> -#define SEC_CORE_WORK_WORK_TIME_CNT_REG			0x0864
> -#define SEC_BACK_WORK_TIME_CNT_REG			0x0868
> -#define SEC_SAA_IDLE_TIME_CNT_REG			0x086c
> -#define SEC_SAA_CLK_CNT_REG				0x0870
> -
> -/* SEC_COMMON registers */
> -#define SEC_CLK_EN_REG					0x0000
> -#define SEC_CTRL_REG					0x0004
> -
> -#define SEC_COMMON_CNT_CLR_CE_REG			0x0008
> -#define   SEC_COMMON_CNT_CLR_CE_CLEAR			BIT(0)
> -#define   SEC_COMMON_CNT_CLR_CE_SNAP_EN			BIT(1)
> -
> -#define SEC_SECURE_CTRL_REG				0x000c
> -#define SEC_AXI_CACHE_CFG_REG				0x0010
> -#define SEC_AXI_QOS_CFG_REG				0x0014
> -#define SEC_IPV4_MASK_TABLE_REG				0x0020
> -#define SEC_IPV6_MASK_TABLE_X_REG(x)	(0x0024 + (x) * 4)
> -#define SEC_FSM_MAX_CNT_REG				0x0064
> -
> -#define SEC_CTRL2_REG					0x0068
> -#define   SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_M		GENMASK(3, 0)
> -#define   SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_S		0
> -#define   SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_M		GENMASK(6, 4)
> -#define   SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_S		4
> -#define   SEC_CTRL2_CLK_GATE_EN				BIT(7)
> -#define   SEC_CTRL2_ENDIAN_BD				BIT(8)
> -#define   SEC_CTRL2_ENDIAN_BD_TYPE			BIT(9)
> -
> -#define SEC_CNT_PRECISION_CFG_REG			0x006c
> -#define SEC_DEBUG_BD_CFG_REG				0x0070
> -#define   SEC_DEBUG_BD_CFG_WB_NORMAL			BIT(0)
> -#define   SEC_DEBUG_BD_CFG_WB_EN			BIT(1)
> -
> -#define SEC_Q_SIGHT_SEL					0x0074
> -#define SEC_Q_SIGHT_HIS_CLR				0x0078
> -#define SEC_Q_VMID_CFG_REG(q)		(0x0100 + (q) * 4)
> -#define SEC_Q_WEIGHT_CFG_REG(q)		(0x200 + (q) * 4)
> -#define SEC_STAT_CLR_REG				0x0a00
> -#define SEC_SAA_IDLE_CNT_CLR_REG			0x0a04
> -#define SEC_QM_CPL_Q_IDBUF_DFX_CFG_REG			0x0b00
> -#define SEC_QM_CPL_Q_IDBUF_DFX_RESULT_REG		0x0b04
> -#define SEC_QM_BD_DFX_CFG_REG				0x0b08
> -#define SEC_QM_BD_DFX_RESULT_REG			0x0b0c
> -#define SEC_QM_BDID_DFX_RESULT_REG			0x0b10
> -#define SEC_QM_BD_DFIFO_STATUS_REG			0x0b14
> -#define SEC_QM_BD_DFX_CFG2_REG				0x0b1c
> -#define SEC_QM_BD_DFX_RESULT2_REG			0x0b20
> -#define SEC_QM_BD_IDFIFO_STATUS_REG			0x0b18
> -#define SEC_QM_BD_DFIFO_STATUS2_REG			0x0b28
> -#define SEC_QM_BD_IDFIFO_STATUS2_REG			0x0b2c
> -
> -#define SEC_HASH_IPV4_MASK				0xfff00000
> -#define SEC_MAX_SAA_NUM					0xa
> -#define SEC_SAA_ADDR_SIZE				0x1000
> -
> -#define SEC_Q_INIT_REG					0x0
> -#define   SEC_Q_INIT_WO_STAT_CLEAR			0x2
> -#define   SEC_Q_INIT_AND_STAT_CLEAR			0x3
> -
> -#define SEC_Q_CFG_REG					0x8
> -#define   SEC_Q_CFG_REORDER				BIT(0)
> -
> -#define SEC_Q_PROC_NUM_CFG_REG				0x10
> -#define SEC_QUEUE_ENB_REG				0x18
> -
> -#define SEC_Q_DEPTH_CFG_REG				0x50
> -#define   SEC_Q_DEPTH_CFG_DEPTH_M			GENMASK(11, 0)
> -#define   SEC_Q_DEPTH_CFG_DEPTH_S			0
> -
> -#define SEC_Q_BASE_HADDR_REG				0x54
> -#define SEC_Q_BASE_LADDR_REG				0x58
> -#define SEC_Q_WR_PTR_REG				0x5c
> -#define SEC_Q_OUTORDER_BASE_HADDR_REG			0x60
> -#define SEC_Q_OUTORDER_BASE_LADDR_REG			0x64
> -#define SEC_Q_OUTORDER_RD_PTR_REG			0x68
> -#define SEC_Q_OT_TH_REG					0x6c
> -
> -#define SEC_Q_ARUSER_CFG_REG				0x70
> -#define   SEC_Q_ARUSER_CFG_FA				BIT(0)
> -#define   SEC_Q_ARUSER_CFG_FNA				BIT(1)
> -#define   SEC_Q_ARUSER_CFG_RINVLD			BIT(2)
> -#define   SEC_Q_ARUSER_CFG_PKG				BIT(3)
> -
> -#define SEC_Q_AWUSER_CFG_REG				0x74
> -#define   SEC_Q_AWUSER_CFG_FA				BIT(0)
> -#define   SEC_Q_AWUSER_CFG_FNA				BIT(1)
> -#define   SEC_Q_AWUSER_CFG_PKG				BIT(2)
> -
> -#define SEC_Q_ERR_BASE_HADDR_REG			0x7c
> -#define SEC_Q_ERR_BASE_LADDR_REG			0x80
> -#define SEC_Q_CFG_VF_NUM_REG				0x84
> -#define SEC_Q_SOFT_PROC_PTR_REG				0x88
> -#define SEC_Q_FAIL_INT_MSK_REG				0x300
> -#define SEC_Q_FLOW_INT_MKS_REG				0x304
> -#define SEC_Q_FAIL_RINT_REG				0x400
> -#define SEC_Q_FLOW_RINT_REG				0x404
> -#define SEC_Q_FAIL_INT_STATUS_REG			0x500
> -#define SEC_Q_FLOW_INT_STATUS_REG			0x504
> -#define SEC_Q_STATUS_REG				0x600
> -#define SEC_Q_RD_PTR_REG				0x604
> -#define SEC_Q_PRO_PTR_REG				0x608
> -#define SEC_Q_OUTORDER_WR_PTR_REG			0x60c
> -#define SEC_Q_OT_CNT_STATUS_REG				0x610
> -#define SEC_Q_INORDER_BD_NUM_ST_REG			0x650
> -#define SEC_Q_INORDER_GET_FLAG_ST_REG			0x654
> -#define SEC_Q_INORDER_ADD_FLAG_ST_REG			0x658
> -#define SEC_Q_INORDER_TASK_INT_NUM_LEFT_ST_REG		0x65c
> -#define SEC_Q_RD_DONE_PTR_REG				0x660
> -#define SEC_Q_CPL_Q_BD_NUM_ST_REG			0x700
> -#define SEC_Q_CPL_Q_PTR_ST_REG				0x704
> -#define SEC_Q_CPL_Q_H_ADDR_ST_REG			0x708
> -#define SEC_Q_CPL_Q_L_ADDR_ST_REG			0x70c
> -#define SEC_Q_CPL_TASK_INT_NUM_LEFT_ST_REG		0x710
> -#define SEC_Q_WRR_ID_CHECK_REG				0x714
> -#define SEC_Q_CPLQ_FULL_CHECK_REG			0x718
> -#define SEC_Q_SUCCESS_BD_CNT_REG			0x800
> -#define SEC_Q_FAIL_BD_CNT_REG				0x804
> -#define SEC_Q_GET_BD_CNT_REG				0x808
> -#define SEC_Q_IVLD_CNT_REG				0x80c
> -#define SEC_Q_BD_PROC_GET_CNT_REG			0x810
> -#define SEC_Q_BD_PROC_DONE_CNT_REG			0x814
> -#define SEC_Q_LAT_CLR_REG				0x850
> -#define SEC_Q_PKT_LAT_MAX_REG				0x854
> -#define SEC_Q_PKT_LAT_AVG_REG				0x858
> -#define SEC_Q_PKT_LAT_MIN_REG				0x85c
> -#define SEC_Q_ID_CLR_CFG_REG				0x900
> -#define SEC_Q_1ST_BD_ERR_ID_REG				0x904
> -#define SEC_Q_1ST_AUTH_FAIL_ID_REG			0x908
> -#define SEC_Q_1ST_RD_ERR_ID_REG				0x90c
> -#define SEC_Q_1ST_ECC2_ERR_ID_REG			0x910
> -#define SEC_Q_1ST_IVLD_ID_REG				0x914
> -#define SEC_Q_1ST_BD_WR_ERR_ID_REG			0x918
> -#define SEC_Q_1ST_ERR_BD_WR_ERR_ID_REG			0x91c
> -#define SEC_Q_1ST_BD_MAC_WR_ERR_ID_REG			0x920
> -
> -struct sec_debug_bd_info {
> -#define SEC_DEBUG_BD_INFO_SOFT_ERR_CHECK_M	GENMASK(22, 0)
> -	u32 soft_err_check;
> -#define SEC_DEBUG_BD_INFO_HARD_ERR_CHECK_M	GENMASK(9, 0)
> -	u32 hard_err_check;
> -	u32 icv_mac1st_word;
> -#define SEC_DEBUG_BD_INFO_GET_ID_M		GENMASK(19, 0)
> -	u32 sec_get_id;
> -	/* W4---W15 */
> -	u32 reserv_left[12];
> -};
> -
> -struct sec_out_bd_info	{
> -#define SEC_OUT_BD_INFO_Q_ID_M			GENMASK(11, 0)
> -#define SEC_OUT_BD_INFO_ECC_2BIT_ERR		BIT(14)
> -	u16 data;
> -};
> -
> -#define SEC_MAX_DEVICES				8
> -static struct sec_dev_info *sec_devices[SEC_MAX_DEVICES];
> -static DEFINE_MUTEX(sec_id_lock);
> -
> -static int sec_queue_map_io(struct sec_queue *queue)
> -{
> -	struct device *dev = queue->dev_info->dev;
> -	struct resource *res;
> -
> -	res = platform_get_resource(to_platform_device(dev),
> -				    IORESOURCE_MEM,
> -				    2 + queue->queue_id);
> -	if (!res) {
> -		dev_err(dev, "Failed to get queue %u memory resource\n",
> -			queue->queue_id);
> -		return -ENOMEM;
> -	}
> -	queue->regs = ioremap(res->start, resource_size(res));
> -	if (!queue->regs)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -
> -static void sec_queue_unmap_io(struct sec_queue *queue)
> -{
> -	 iounmap(queue->regs);
> -}
> -
> -static int sec_queue_ar_pkgattr(struct sec_queue *queue, u32 ar_pkg)
> -{
> -	void __iomem *addr = queue->regs +  SEC_Q_ARUSER_CFG_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (ar_pkg)
> -		regval |= SEC_Q_ARUSER_CFG_PKG;
> -	else
> -		regval &= ~SEC_Q_ARUSER_CFG_PKG;
> -	writel_relaxed(regval, addr);
> -
> -	return 0;
> -}
> -
> -static int sec_queue_aw_pkgattr(struct sec_queue *queue, u32 aw_pkg)
> -{
> -	void __iomem *addr = queue->regs + SEC_Q_AWUSER_CFG_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	regval |= SEC_Q_AWUSER_CFG_PKG;
> -	writel_relaxed(regval, addr);
> -
> -	return 0;
> -}
> -
> -static int sec_clk_en(struct sec_dev_info *info)
> -{
> -	void __iomem *base = info->regs[SEC_COMMON];
> -	u32 i = 0;
> -
> -	writel_relaxed(0x7, base + SEC_ALGSUB_CLK_EN_REG);
> -	do {
> -		usleep_range(1000, 10000);
> -		if ((readl_relaxed(base + SEC_ALGSUB_CLK_ST_REG) & 0x7) == 0x7)
> -			return 0;
> -		i++;
> -	} while (i < 10);
> -	dev_err(info->dev, "sec clock enable fail!\n");
> -
> -	return -EIO;
> -}
> -
> -static int sec_clk_dis(struct sec_dev_info *info)
> -{
> -	void __iomem *base = info->regs[SEC_COMMON];
> -	u32 i = 0;
> -
> -	writel_relaxed(0x7, base + SEC_ALGSUB_CLK_DIS_REG);
> -	do {
> -		usleep_range(1000, 10000);
> -		if ((readl_relaxed(base + SEC_ALGSUB_CLK_ST_REG) & 0x7) == 0)
> -			return 0;
> -		i++;
> -	} while (i < 10);
> -	dev_err(info->dev, "sec clock disable fail!\n");
> -
> -	return -EIO;
> -}
> -
> -static int sec_reset_whole_module(struct sec_dev_info *info)
> -{
> -	void __iomem *base = info->regs[SEC_COMMON];
> -	bool is_reset, b_is_reset;
> -	u32 i = 0;
> -
> -	writel_relaxed(1, base + SEC_ALGSUB_RST_REQ_REG);
> -	writel_relaxed(1, base + SEC_ALGSUB_BUILD_RST_REQ_REG);
> -	while (1) {
> -		usleep_range(1000, 10000);
> -		is_reset = readl_relaxed(base + SEC_ALGSUB_RST_ST_REG) &
> -			SEC_ALGSUB_RST_ST_IS_RST;
> -		b_is_reset = readl_relaxed(base + SEC_ALGSUB_BUILD_RST_ST_REG) &
> -			SEC_ALGSUB_BUILD_RST_ST_IS_RST;
> -		if (is_reset && b_is_reset)
> -			break;
> -		i++;
> -		if (i > 10) {
> -			dev_err(info->dev, "Reset req failed\n");
> -			return -EIO;
> -		}
> -	}
> -
> -	i = 0;
> -	writel_relaxed(1, base + SEC_ALGSUB_RST_DREQ_REG);
> -	writel_relaxed(1, base + SEC_ALGSUB_BUILD_RST_DREQ_REG);
> -	while (1) {
> -		usleep_range(1000, 10000);
> -		is_reset = readl_relaxed(base + SEC_ALGSUB_RST_ST_REG) &
> -			SEC_ALGSUB_RST_ST_IS_RST;
> -		b_is_reset = readl_relaxed(base + SEC_ALGSUB_BUILD_RST_ST_REG) &
> -			SEC_ALGSUB_BUILD_RST_ST_IS_RST;
> -		if (!is_reset && !b_is_reset)
> -			break;
> -
> -		i++;
> -		if (i > 10) {
> -			dev_err(info->dev, "Reset dreq failed\n");
> -			return -EIO;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static void sec_bd_endian_little(struct sec_dev_info *info)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_CTRL2_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	regval &= ~(SEC_CTRL2_ENDIAN_BD | SEC_CTRL2_ENDIAN_BD_TYPE);
> -	writel_relaxed(regval, addr);
> -}
> -
> -/*
> - * sec_cache_config - configure optimum cache placement
> - */
> -static void sec_cache_config(struct sec_dev_info *info)
> -{
> -	struct iommu_domain *domain;
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_CTRL_REG;
> -
> -	domain = iommu_get_domain_for_dev(info->dev);
> -
> -	/* Check that translation is occurring */
> -	if (domain && (domain->type & __IOMMU_DOMAIN_PAGING))
> -		writel_relaxed(0x44cf9e, addr);
> -	else
> -		writel_relaxed(0x4cfd9, addr);
> -}
> -
> -static void sec_data_axiwr_otsd_cfg(struct sec_dev_info *info, u32 cfg)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_CTRL2_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	regval &= ~SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_M;
> -	regval |= (cfg << SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_S) &
> -		SEC_CTRL2_DATA_AXI_WR_OTSD_CFG_M;
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_data_axird_otsd_cfg(struct sec_dev_info *info, u32 cfg)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_CTRL2_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	regval &= ~SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_M;
> -	regval |= (cfg << SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_S) &
> -		SEC_CTRL2_DATA_AXI_RD_OTSD_CFG_M;
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_clk_gate_en(struct sec_dev_info *info, bool clkgate)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_CTRL2_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (clkgate)
> -		regval |= SEC_CTRL2_CLK_GATE_EN;
> -	else
> -		regval &= ~SEC_CTRL2_CLK_GATE_EN;
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_comm_cnt_cfg(struct sec_dev_info *info, bool clr_ce)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_COMMON_CNT_CLR_CE_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (clr_ce)
> -		regval |= SEC_COMMON_CNT_CLR_CE_CLEAR;
> -	else
> -		regval &= ~SEC_COMMON_CNT_CLR_CE_CLEAR;
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_commsnap_en(struct sec_dev_info *info, bool snap_en)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_COMMON_CNT_CLR_CE_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (snap_en)
> -		regval |= SEC_COMMON_CNT_CLR_CE_SNAP_EN;
> -	else
> -		regval &= ~SEC_COMMON_CNT_CLR_CE_SNAP_EN;
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_ipv6_hashmask(struct sec_dev_info *info, u32 hash_mask[])
> -{
> -	void __iomem *base = info->regs[SEC_SAA];
> -	int i;
> -
> -	for (i = 0; i < 10; i++)
> -		writel_relaxed(hash_mask[0],
> -			       base + SEC_IPV6_MASK_TABLE_X_REG(i));
> -}
> -
> -static int sec_ipv4_hashmask(struct sec_dev_info *info, u32 hash_mask)
> -{
> -	if (hash_mask & SEC_HASH_IPV4_MASK) {
> -		dev_err(info->dev, "Sec Ipv4 Hash Mask Input Error!\n");
> -		return -EINVAL;
> -	}
> -
> -	writel_relaxed(hash_mask,
> -		       info->regs[SEC_SAA] + SEC_IPV4_MASK_TABLE_REG);
> -
> -	return 0;
> -}
> -
> -static void sec_set_dbg_bd_cfg(struct sec_dev_info *info, u32 cfg)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_DEBUG_BD_CFG_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	/* Always disable write back of normal bd */
> -	regval &= ~SEC_DEBUG_BD_CFG_WB_NORMAL;
> -
> -	if (cfg)
> -		regval &= ~SEC_DEBUG_BD_CFG_WB_EN;
> -	else
> -		regval |= SEC_DEBUG_BD_CFG_WB_EN;
> -
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_saa_getqm_en(struct sec_dev_info *info, u32 saa_indx, u32 en)
> -{
> -	void __iomem *addr = info->regs[SEC_SAA] + SEC_SAA_BASE +
> -		SEC_SAA_CTRL_REG(saa_indx);
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (en)
> -		regval |= SEC_SAA_CTRL_GET_QM_EN;
> -	else
> -		regval &= ~SEC_SAA_CTRL_GET_QM_EN;
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_saa_int_mask(struct sec_dev_info *info, u32 saa_indx,
> -			     u32 saa_int_mask)
> -{
> -	writel_relaxed(saa_int_mask,
> -		       info->regs[SEC_SAA] + SEC_SAA_BASE + SEC_ST_INTMSK1_REG +
> -		       saa_indx * SEC_SAA_ADDR_SIZE);
> -}
> -
> -static void sec_streamid(struct sec_dev_info *info, int i)
> -{
> -	#define SEC_SID 0x600
> -	#define SEC_VMID 0
> -
> -	writel_relaxed((SEC_VMID | ((SEC_SID & 0xffff) << 8)),
> -		       info->regs[SEC_SAA] + SEC_Q_VMID_CFG_REG(i));
> -}
> -
> -static void sec_queue_ar_alloc(struct sec_queue *queue, u32 alloc)
> -{
> -	void __iomem *addr = queue->regs + SEC_Q_ARUSER_CFG_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (alloc == SEC_QUEUE_AR_FROCE_ALLOC) {
> -		regval |= SEC_Q_ARUSER_CFG_FA;
> -		regval &= ~SEC_Q_ARUSER_CFG_FNA;
> -	} else {
> -		regval &= ~SEC_Q_ARUSER_CFG_FA;
> -		regval |= SEC_Q_ARUSER_CFG_FNA;
> -	}
> -
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_queue_aw_alloc(struct sec_queue *queue, u32 alloc)
> -{
> -	void __iomem *addr = queue->regs + SEC_Q_AWUSER_CFG_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	if (alloc == SEC_QUEUE_AW_FROCE_ALLOC) {
> -		regval |= SEC_Q_AWUSER_CFG_FA;
> -		regval &= ~SEC_Q_AWUSER_CFG_FNA;
> -	} else {
> -		regval &= ~SEC_Q_AWUSER_CFG_FA;
> -		regval |= SEC_Q_AWUSER_CFG_FNA;
> -	}
> -
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_queue_reorder(struct sec_queue *queue, bool reorder)
> -{
> -	void __iomem *base = queue->regs;
> -	u32 regval;
> -
> -	regval = readl_relaxed(base + SEC_Q_CFG_REG);
> -	if (reorder)
> -		regval |= SEC_Q_CFG_REORDER;
> -	else
> -		regval &= ~SEC_Q_CFG_REORDER;
> -	writel_relaxed(regval, base + SEC_Q_CFG_REG);
> -}
> -
> -static void sec_queue_depth(struct sec_queue *queue, u32 depth)
> -{
> -	void __iomem *addr = queue->regs + SEC_Q_DEPTH_CFG_REG;
> -	u32 regval;
> -
> -	regval = readl_relaxed(addr);
> -	regval &= ~SEC_Q_DEPTH_CFG_DEPTH_M;
> -	regval |= (depth << SEC_Q_DEPTH_CFG_DEPTH_S) & SEC_Q_DEPTH_CFG_DEPTH_M;
> -
> -	writel_relaxed(regval, addr);
> -}
> -
> -static void sec_queue_cmdbase_addr(struct sec_queue *queue, u64 addr)
> -{
> -	writel_relaxed(upper_32_bits(addr), queue->regs + SEC_Q_BASE_HADDR_REG);
> -	writel_relaxed(lower_32_bits(addr), queue->regs + SEC_Q_BASE_LADDR_REG);
> -}
> -
> -static void sec_queue_outorder_addr(struct sec_queue *queue, u64 addr)
> -{
> -	writel_relaxed(upper_32_bits(addr),
> -		       queue->regs + SEC_Q_OUTORDER_BASE_HADDR_REG);
> -	writel_relaxed(lower_32_bits(addr),
> -		       queue->regs + SEC_Q_OUTORDER_BASE_LADDR_REG);
> -}
> -
> -static void sec_queue_errbase_addr(struct sec_queue *queue, u64 addr)
> -{
> -	writel_relaxed(upper_32_bits(addr),
> -		       queue->regs + SEC_Q_ERR_BASE_HADDR_REG);
> -	writel_relaxed(lower_32_bits(addr),
> -		       queue->regs + SEC_Q_ERR_BASE_LADDR_REG);
> -}
> -
> -static void sec_queue_irq_disable(struct sec_queue *queue)
> -{
> -	writel_relaxed((u32)~0, queue->regs + SEC_Q_FLOW_INT_MKS_REG);
> -}
> -
> -static void sec_queue_irq_enable(struct sec_queue *queue)
> -{
> -	writel_relaxed(0, queue->regs + SEC_Q_FLOW_INT_MKS_REG);
> -}
> -
> -static void sec_queue_abn_irq_disable(struct sec_queue *queue)
> -{
> -	writel_relaxed((u32)~0, queue->regs + SEC_Q_FAIL_INT_MSK_REG);
> -}
> -
> -static void sec_queue_stop(struct sec_queue *queue)
> -{
> -	disable_irq(queue->task_irq);
> -	sec_queue_irq_disable(queue);
> -	writel_relaxed(0x0, queue->regs + SEC_QUEUE_ENB_REG);
> -}
> -
> -static void sec_queue_start(struct sec_queue *queue)
> -{
> -	sec_queue_irq_enable(queue);
> -	enable_irq(queue->task_irq);
> -	queue->expected = 0;
> -	writel_relaxed(SEC_Q_INIT_AND_STAT_CLEAR, queue->regs + SEC_Q_INIT_REG);
> -	writel_relaxed(0x1, queue->regs + SEC_QUEUE_ENB_REG);
> -}
> -
> -static struct sec_queue *sec_alloc_queue(struct sec_dev_info *info)
> -{
> -	int i;
> -
> -	mutex_lock(&info->dev_lock);
> -
> -	/* Get the first idle queue in SEC device */
> -	for (i = 0; i < SEC_Q_NUM; i++)
> -		if (!info->queues[i].in_use) {
> -			info->queues[i].in_use = true;
> -			info->queues_in_use++;
> -			mutex_unlock(&info->dev_lock);
> -
> -			return &info->queues[i];
> -		}
> -	mutex_unlock(&info->dev_lock);
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static int sec_queue_free(struct sec_queue *queue)
> -{
> -	struct sec_dev_info *info = queue->dev_info;
> -
> -	if (queue->queue_id >= SEC_Q_NUM) {
> -		dev_err(info->dev, "No queue %u\n", queue->queue_id);
> -		return -ENODEV;
> -	}
> -
> -	if (!queue->in_use) {
> -		dev_err(info->dev, "Queue %u is idle\n", queue->queue_id);
> -		return -ENODEV;
> -	}
> -
> -	mutex_lock(&info->dev_lock);
> -	queue->in_use = false;
> -	info->queues_in_use--;
> -	mutex_unlock(&info->dev_lock);
> -
> -	return 0;
> -}
> -
> -static irqreturn_t sec_isr_handle_th(int irq, void *q)
> -{
> -	sec_queue_irq_disable(q);
> -	return IRQ_WAKE_THREAD;
> -}
> -
> -static irqreturn_t sec_isr_handle(int irq, void *q)
> -{
> -	struct sec_queue *queue = q;
> -	struct sec_queue_ring_cmd *msg_ring = &queue->ring_cmd;
> -	struct sec_queue_ring_cq *cq_ring = &queue->ring_cq;
> -	struct sec_out_bd_info *outorder_msg;
> -	struct sec_bd_info *msg;
> -	u32 ooo_read, ooo_write;
> -	void __iomem *base = queue->regs;
> -	int q_id;
> -
> -	ooo_read = readl(base + SEC_Q_OUTORDER_RD_PTR_REG);
> -	ooo_write = readl(base + SEC_Q_OUTORDER_WR_PTR_REG);
> -	outorder_msg = cq_ring->vaddr + ooo_read;
> -	q_id = outorder_msg->data & SEC_OUT_BD_INFO_Q_ID_M;
> -	msg = msg_ring->vaddr + q_id;
> -
> -	while ((ooo_write != ooo_read) && msg->w0 & SEC_BD_W0_DONE) {
> -		/*
> -		 * Must be before callback otherwise blocks adding other chained
> -		 * elements
> -		 */
> -		set_bit(q_id, queue->unprocessed);
> -		if (q_id == queue->expected)
> -			while (test_bit(queue->expected, queue->unprocessed)) {
> -				clear_bit(queue->expected, queue->unprocessed);
> -				msg = msg_ring->vaddr + queue->expected;
> -				msg->w0 &= ~SEC_BD_W0_DONE;
> -				msg_ring->callback(msg,
> -						queue->shadow[queue->expected]);
> -				queue->shadow[queue->expected] = NULL;
> -				queue->expected = (queue->expected + 1) %
> -					SEC_QUEUE_LEN;
> -				atomic_dec(&msg_ring->used);
> -			}
> -
> -		ooo_read = (ooo_read + 1) % SEC_QUEUE_LEN;
> -		writel(ooo_read, base + SEC_Q_OUTORDER_RD_PTR_REG);
> -		ooo_write = readl(base + SEC_Q_OUTORDER_WR_PTR_REG);
> -		outorder_msg = cq_ring->vaddr + ooo_read;
> -		q_id = outorder_msg->data & SEC_OUT_BD_INFO_Q_ID_M;
> -		msg = msg_ring->vaddr + q_id;
> -	}
> -
> -	sec_queue_irq_enable(queue);
> -
> -	return IRQ_HANDLED;
> -}
> -
> -static int sec_queue_irq_init(struct sec_queue *queue)
> -{
> -	struct sec_dev_info *info = queue->dev_info;
> -	int irq = queue->task_irq;
> -	int ret;
> -
> -	ret = request_threaded_irq(irq, sec_isr_handle_th, sec_isr_handle,
> -				   IRQF_TRIGGER_RISING, queue->name, queue);
> -	if (ret) {
> -		dev_err(info->dev, "request irq(%d) failed %d\n", irq, ret);
> -		return ret;
> -	}
> -	disable_irq(irq);
> -
> -	return 0;
> -}
> -
> -static int sec_queue_irq_uninit(struct sec_queue *queue)
> -{
> -	free_irq(queue->task_irq, queue);
> -
> -	return 0;
> -}
> -
> -static struct sec_dev_info *sec_device_get(void)
> -{
> -	struct sec_dev_info *sec_dev = NULL;
> -	struct sec_dev_info *this_sec_dev;
> -	int least_busy_n = SEC_Q_NUM + 1;
> -	int i;
> -
> -	/* Find which one is least busy and use that first */
> -	for (i = 0; i < SEC_MAX_DEVICES; i++) {
> -		this_sec_dev = sec_devices[i];
> -		if (this_sec_dev &&
> -		    this_sec_dev->queues_in_use < least_busy_n) {
> -			least_busy_n = this_sec_dev->queues_in_use;
> -			sec_dev = this_sec_dev;
> -		}
> -	}
> -
> -	return sec_dev;
> -}
> -
> -static struct sec_queue *sec_queue_alloc_start(struct sec_dev_info *info)
> -{
> -	struct sec_queue *queue;
> -
> -	queue = sec_alloc_queue(info);
> -	if (IS_ERR(queue)) {
> -		dev_err(info->dev, "alloc sec queue failed! %ld\n",
> -			PTR_ERR(queue));
> -		return queue;
> -	}
> -
> -	sec_queue_start(queue);
> -
> -	return queue;
> -}
> -
> -/**
> - * sec_queue_alloc_start_safe - get a hw queue from appropriate instance
> - *
> - * This function does extremely simplistic load balancing. It does not take into
> - * account NUMA locality of the accelerator, or which cpu has requested the
> - * queue.  Future work may focus on optimizing this in order to improve full
> - * machine throughput.
> - */
> -struct sec_queue *sec_queue_alloc_start_safe(void)
> -{
> -	struct sec_dev_info *info;
> -	struct sec_queue *queue = ERR_PTR(-ENODEV);
> -
> -	mutex_lock(&sec_id_lock);
> -	info = sec_device_get();
> -	if (!info)
> -		goto unlock;
> -
> -	queue = sec_queue_alloc_start(info);
> -
> -unlock:
> -	mutex_unlock(&sec_id_lock);
> -
> -	return queue;
> -}
> -
> -/**
> - * sec_queue_stop_release() - free up a hw queue for reuse
> - * @queue: The queue we are done with.
> - *
> - * This will stop the current queue, terminanting any transactions
> - * that are inflight an return it to the pool of available hw queuess
> - */
> -int sec_queue_stop_release(struct sec_queue *queue)
> -{
> -	struct device *dev = queue->dev_info->dev;
> -	int ret;
> -
> -	sec_queue_stop(queue);
> -
> -	ret = sec_queue_free(queue);
> -	if (ret)
> -		dev_err(dev, "Releasing queue failed %d\n", ret);
> -
> -	return ret;
> -}
> -
> -/**
> - * sec_queue_empty() - Is this hardware queue currently empty.
> - * @queue: The queue to test
> - *
> - * We need to know if we have an empty queue for some of the chaining modes
> - * as if it is not empty we may need to hold the message in a software queue
> - * until the hw queue is drained.
> - */
> -bool sec_queue_empty(struct sec_queue *queue)
> -{
> -	struct sec_queue_ring_cmd *msg_ring = &queue->ring_cmd;
> -
> -	return !atomic_read(&msg_ring->used);
> -}
> -
> -/**
> - * sec_queue_send() - queue up a single operation in the hw queue
> - * @queue: The queue in which to put the message
> - * @msg: The message
> - * @ctx: Context to be put in the shadow array and passed back to cb on result.
> - *
> - * This function will return -EAGAIN if the queue is currently full.
> - */
> -int sec_queue_send(struct sec_queue *queue, struct sec_bd_info *msg, void *ctx)
> -{
> -	struct sec_queue_ring_cmd *msg_ring = &queue->ring_cmd;
> -	void __iomem *base = queue->regs;
> -	u32 write, read;
> -
> -	mutex_lock(&msg_ring->lock);
> -	read = readl(base + SEC_Q_RD_PTR_REG);
> -	write = readl(base + SEC_Q_WR_PTR_REG);
> -	if (write == read && atomic_read(&msg_ring->used) == SEC_QUEUE_LEN) {
> -		mutex_unlock(&msg_ring->lock);
> -		return -EAGAIN;
> -	}
> -	memcpy(msg_ring->vaddr + write, msg, sizeof(*msg));
> -	queue->shadow[write] = ctx;
> -	write = (write + 1) % SEC_QUEUE_LEN;
> -
> -	/* Ensure content updated before queue advance */
> -	wmb();
> -	writel(write, base + SEC_Q_WR_PTR_REG);
> -
> -	atomic_inc(&msg_ring->used);
> -	mutex_unlock(&msg_ring->lock);
> -
> -	return 0;
> -}
> -
> -bool sec_queue_can_enqueue(struct sec_queue *queue, int num)
> -{
> -	struct sec_queue_ring_cmd *msg_ring = &queue->ring_cmd;
> -
> -	return SEC_QUEUE_LEN - atomic_read(&msg_ring->used) >= num;
> -}
> -
> -static void sec_queue_hw_init(struct sec_queue *queue)
> -{
> -	sec_queue_ar_alloc(queue, SEC_QUEUE_AR_FROCE_NOALLOC);
> -	sec_queue_aw_alloc(queue, SEC_QUEUE_AW_FROCE_NOALLOC);
> -	sec_queue_ar_pkgattr(queue, 1);
> -	sec_queue_aw_pkgattr(queue, 1);
> -
> -	/* Enable out of order queue */
> -	sec_queue_reorder(queue, true);
> -
> -	/* Interrupt after a single complete element */
> -	writel_relaxed(1, queue->regs + SEC_Q_PROC_NUM_CFG_REG);
> -
> -	sec_queue_depth(queue, SEC_QUEUE_LEN - 1);
> -
> -	sec_queue_cmdbase_addr(queue, queue->ring_cmd.paddr);
> -
> -	sec_queue_outorder_addr(queue, queue->ring_cq.paddr);
> -
> -	sec_queue_errbase_addr(queue, queue->ring_db.paddr);
> -
> -	writel_relaxed(0x100, queue->regs + SEC_Q_OT_TH_REG);
> -
> -	sec_queue_abn_irq_disable(queue);
> -	sec_queue_irq_disable(queue);
> -	writel_relaxed(SEC_Q_INIT_AND_STAT_CLEAR, queue->regs + SEC_Q_INIT_REG);
> -}
> -
> -static int sec_hw_init(struct sec_dev_info *info)
> -{
> -	struct iommu_domain *domain;
> -	u32 sec_ipv4_mask = 0;
> -	u32 sec_ipv6_mask[10] = {};
> -	int ret;
> -	u32 i;
> -
> -	domain = iommu_get_domain_for_dev(info->dev);
> -
> -	/*
> -	 * Enable all available processing unit clocks.
> -	 * Only the first cluster is usable with translations.
> -	 */
> -	if (domain && (domain->type & __IOMMU_DOMAIN_PAGING))
> -		info->num_saas = 5;
> -
> -	else
> -		info->num_saas = 10;
> -
> -	writel_relaxed(GENMASK(info->num_saas - 1, 0),
> -		       info->regs[SEC_SAA] + SEC_CLK_EN_REG);
> -
> -	/* 32 bit little endian */
> -	sec_bd_endian_little(info);
> -
> -	sec_cache_config(info);
> -
> -	/* Data axi port write and read outstanding config as per datasheet */
> -	sec_data_axiwr_otsd_cfg(info, 0x7);
> -	sec_data_axird_otsd_cfg(info, 0x7);
> -
> -	/* Enable clock gating */
> -	sec_clk_gate_en(info, true);
> -
> -	/* Set CNT_CYC register not read clear */
> -	sec_comm_cnt_cfg(info, false);
> -
> -	/* Enable CNT_CYC */
> -	sec_commsnap_en(info, false);
> -
> -	writel_relaxed((u32)~0, info->regs[SEC_SAA] + SEC_FSM_MAX_CNT_REG);
> -
> -	ret = sec_ipv4_hashmask(info, sec_ipv4_mask);
> -	if (ret) {
> -		dev_err(info->dev, "Failed to set ipv4 hashmask %d\n", ret);
> -		return -EIO;
> -	}
> -
> -	sec_ipv6_hashmask(info, sec_ipv6_mask);
> -
> -	/*  do not use debug bd */
> -	sec_set_dbg_bd_cfg(info, 0);
> -
> -	if (domain && (domain->type & __IOMMU_DOMAIN_PAGING)) {
> -		for (i = 0; i < SEC_Q_NUM; i++) {
> -			sec_streamid(info, i);
> -			/* Same QoS for all queues */
> -			writel_relaxed(0x3f,
> -				       info->regs[SEC_SAA] +
> -				       SEC_Q_WEIGHT_CFG_REG(i));
> -		}
> -	}
> -
> -	for (i = 0; i < info->num_saas; i++) {
> -		sec_saa_getqm_en(info, i, 1);
> -		sec_saa_int_mask(info, i, 0);
> -	}
> -
> -	return 0;
> -}
> -
> -static void sec_hw_exit(struct sec_dev_info *info)
> -{
> -	int i;
> -
> -	for (i = 0; i < SEC_MAX_SAA_NUM; i++) {
> -		sec_saa_int_mask(info, i, (u32)~0);
> -		sec_saa_getqm_en(info, i, 0);
> -	}
> -}
> -
> -static void sec_queue_base_init(struct sec_dev_info *info,
> -				struct sec_queue *queue, int queue_id)
> -{
> -	queue->dev_info = info;
> -	queue->queue_id = queue_id;
> -	snprintf(queue->name, sizeof(queue->name),
> -		 "%s_%d", dev_name(info->dev), queue->queue_id);
> -}
> -
> -static int sec_map_io(struct sec_dev_info *info, struct platform_device *pdev)
> -{
> -	int i;
> -
> -	for (i = 0; i < SEC_NUM_ADDR_REGIONS; i++) {
> -		info->regs[i] = devm_platform_ioremap_resource(pdev, i);
> -		if (IS_ERR(info->regs[i]))
> -			return PTR_ERR(info->regs[i]);
> -	}
> -
> -	return 0;
> -}
> -
> -static int sec_base_init(struct sec_dev_info *info,
> -			 struct platform_device *pdev)
> -{
> -	int ret;
> -
> -	ret = sec_map_io(info, pdev);
> -	if (ret)
> -		return ret;
> -
> -	ret = sec_clk_en(info);
> -	if (ret)
> -		return ret;
> -
> -	ret = sec_reset_whole_module(info);
> -	if (ret)
> -		goto sec_clk_disable;
> -
> -	ret = sec_hw_init(info);
> -	if (ret)
> -		goto sec_clk_disable;
> -
> -	return 0;
> -
> -sec_clk_disable:
> -	sec_clk_dis(info);
> -
> -	return ret;
> -}
> -
> -static void sec_base_exit(struct sec_dev_info *info)
> -{
> -	sec_hw_exit(info);
> -	sec_clk_dis(info);
> -}
> -
> -#define SEC_Q_CMD_SIZE \
> -	round_up(SEC_QUEUE_LEN * sizeof(struct sec_bd_info), PAGE_SIZE)
> -#define SEC_Q_CQ_SIZE \
> -	round_up(SEC_QUEUE_LEN * sizeof(struct sec_out_bd_info), PAGE_SIZE)
> -#define SEC_Q_DB_SIZE \
> -	round_up(SEC_QUEUE_LEN * sizeof(struct sec_debug_bd_info), PAGE_SIZE)
> -
> -static int sec_queue_res_cfg(struct sec_queue *queue)
> -{
> -	struct device *dev = queue->dev_info->dev;
> -	struct sec_queue_ring_cmd *ring_cmd = &queue->ring_cmd;
> -	struct sec_queue_ring_cq *ring_cq = &queue->ring_cq;
> -	struct sec_queue_ring_db *ring_db = &queue->ring_db;
> -	int ret;
> -
> -	ring_cmd->vaddr = dma_alloc_coherent(dev, SEC_Q_CMD_SIZE,
> -					     &ring_cmd->paddr, GFP_KERNEL);
> -	if (!ring_cmd->vaddr)
> -		return -ENOMEM;
> -
> -	atomic_set(&ring_cmd->used, 0);
> -	mutex_init(&ring_cmd->lock);
> -	ring_cmd->callback = sec_alg_callback;
> -
> -	ring_cq->vaddr = dma_alloc_coherent(dev, SEC_Q_CQ_SIZE,
> -					    &ring_cq->paddr, GFP_KERNEL);
> -	if (!ring_cq->vaddr) {
> -		ret = -ENOMEM;
> -		goto err_free_ring_cmd;
> -	}
> -
> -	ring_db->vaddr = dma_alloc_coherent(dev, SEC_Q_DB_SIZE,
> -					    &ring_db->paddr, GFP_KERNEL);
> -	if (!ring_db->vaddr) {
> -		ret = -ENOMEM;
> -		goto err_free_ring_cq;
> -	}
> -	queue->task_irq = platform_get_irq(to_platform_device(dev),
> -					   queue->queue_id * 2 + 1);
> -	if (queue->task_irq < 0) {
> -		ret = queue->task_irq;
> -		goto err_free_ring_db;
> -	}
> -
> -	return 0;
> -
> -err_free_ring_db:
> -	dma_free_coherent(dev, SEC_Q_DB_SIZE, queue->ring_db.vaddr,
> -			  queue->ring_db.paddr);
> -err_free_ring_cq:
> -	dma_free_coherent(dev, SEC_Q_CQ_SIZE, queue->ring_cq.vaddr,
> -			  queue->ring_cq.paddr);
> -err_free_ring_cmd:
> -	dma_free_coherent(dev, SEC_Q_CMD_SIZE, queue->ring_cmd.vaddr,
> -			  queue->ring_cmd.paddr);
> -
> -	return ret;
> -}
> -
> -static void sec_queue_free_ring_pages(struct sec_queue *queue)
> -{
> -	struct device *dev = queue->dev_info->dev;
> -
> -	dma_free_coherent(dev, SEC_Q_DB_SIZE, queue->ring_db.vaddr,
> -			  queue->ring_db.paddr);
> -	dma_free_coherent(dev, SEC_Q_CQ_SIZE, queue->ring_cq.vaddr,
> -			  queue->ring_cq.paddr);
> -	dma_free_coherent(dev, SEC_Q_CMD_SIZE, queue->ring_cmd.vaddr,
> -			  queue->ring_cmd.paddr);
> -}
> -
> -static int sec_queue_config(struct sec_dev_info *info, struct sec_queue *queue,
> -			    int queue_id)
> -{
> -	int ret;
> -
> -	sec_queue_base_init(info, queue, queue_id);
> -
> -	ret = sec_queue_res_cfg(queue);
> -	if (ret)
> -		return ret;
> -
> -	ret = sec_queue_map_io(queue);
> -	if (ret) {
> -		dev_err(info->dev, "Queue map failed %d\n", ret);
> -		sec_queue_free_ring_pages(queue);
> -		return ret;
> -	}
> -
> -	sec_queue_hw_init(queue);
> -
> -	return 0;
> -}
> -
> -static void sec_queue_unconfig(struct sec_dev_info *info,
> -			       struct sec_queue *queue)
> -{
> -	sec_queue_unmap_io(queue);
> -	sec_queue_free_ring_pages(queue);
> -}
> -
> -static int sec_id_alloc(struct sec_dev_info *info)
> -{
> -	int ret = 0;
> -	int i;
> -
> -	mutex_lock(&sec_id_lock);
> -
> -	for (i = 0; i < SEC_MAX_DEVICES; i++)
> -		if (!sec_devices[i])
> -			break;
> -	if (i == SEC_MAX_DEVICES) {
> -		ret = -ENOMEM;
> -		goto unlock;
> -	}
> -	info->sec_id = i;
> -	sec_devices[info->sec_id] = info;
> -
> -unlock:
> -	mutex_unlock(&sec_id_lock);
> -
> -	return ret;
> -}
> -
> -static void sec_id_free(struct sec_dev_info *info)
> -{
> -	mutex_lock(&sec_id_lock);
> -	sec_devices[info->sec_id] = NULL;
> -	mutex_unlock(&sec_id_lock);
> -}
> -
> -static int sec_probe(struct platform_device *pdev)
> -{
> -	struct sec_dev_info *info;
> -	struct device *dev = &pdev->dev;
> -	int i, j;
> -	int ret;
> -
> -	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> -	if (ret) {
> -		dev_err(dev, "Failed to set 64 bit dma mask %d", ret);
> -		return -ENODEV;
> -	}
> -
> -	info = devm_kzalloc(dev, (sizeof(*info)), GFP_KERNEL);
> -	if (!info)
> -		return -ENOMEM;
> -
> -	info->dev = dev;
> -	mutex_init(&info->dev_lock);
> -
> -	info->hw_sgl_pool = dmam_pool_create("sgl", dev,
> -					     sizeof(struct sec_hw_sgl), 64, 0);
> -	if (!info->hw_sgl_pool) {
> -		dev_err(dev, "Failed to create sec sgl dma pool\n");
> -		return -ENOMEM;
> -	}
> -
> -	ret = sec_base_init(info, pdev);
> -	if (ret) {
> -		dev_err(dev, "Base initialization fail! %d\n", ret);
> -		return ret;
> -	}
> -
> -	for (i = 0; i < SEC_Q_NUM; i++) {
> -		ret = sec_queue_config(info, &info->queues[i], i);
> -		if (ret)
> -			goto queues_unconfig;
> -
> -		ret = sec_queue_irq_init(&info->queues[i]);
> -		if (ret) {
> -			sec_queue_unconfig(info, &info->queues[i]);
> -			goto queues_unconfig;
> -		}
> -	}
> -
> -	ret = sec_algs_register();
> -	if (ret) {
> -		dev_err(dev, "Failed to register algorithms with crypto %d\n",
> -			ret);
> -		goto queues_unconfig;
> -	}
> -
> -	platform_set_drvdata(pdev, info);
> -
> -	ret = sec_id_alloc(info);
> -	if (ret)
> -		goto algs_unregister;
> -
> -	return 0;
> -
> -algs_unregister:
> -	sec_algs_unregister();
> -queues_unconfig:
> -	for (j = i - 1; j >= 0; j--) {
> -		sec_queue_irq_uninit(&info->queues[j]);
> -		sec_queue_unconfig(info, &info->queues[j]);
> -	}
> -	sec_base_exit(info);
> -
> -	return ret;
> -}
> -
> -static void sec_remove(struct platform_device *pdev)
> -{
> -	struct sec_dev_info *info = platform_get_drvdata(pdev);
> -	int i;
> -
> -	/* Unexpose as soon as possible, reuse during remove is fine */
> -	sec_id_free(info);
> -
> -	sec_algs_unregister();
> -
> -	for (i = 0; i < SEC_Q_NUM; i++) {
> -		sec_queue_irq_uninit(&info->queues[i]);
> -		sec_queue_unconfig(info, &info->queues[i]);
> -	}
> -
> -	sec_base_exit(info);
> -}
> -
> -static const __maybe_unused struct of_device_id sec_match[] = {
> -	{ .compatible = "hisilicon,hip06-sec" },
> -	{ .compatible = "hisilicon,hip07-sec" },
> -	{}
> -};
> -MODULE_DEVICE_TABLE(of, sec_match);
> -
> -static const __maybe_unused struct acpi_device_id sec_acpi_match[] = {
> -	{ "HISI02C1", 0 },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(acpi, sec_acpi_match);
> -
> -static struct platform_driver sec_driver = {
> -	.probe = sec_probe,
> -	.remove = sec_remove,
> -	.driver = {
> -		.name = "hisi_sec_platform_driver",
> -		.of_match_table = sec_match,
> -		.acpi_match_table = ACPI_PTR(sec_acpi_match),
> -	},
> -};
> -module_platform_driver(sec_driver);
> -
> -MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("HiSilicon Security Accelerators");
> -MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com");
> -MODULE_AUTHOR("Jonathan Cameron <jonathan.cameron@huawei.com>");
> diff --git a/drivers/crypto/hisilicon/sec/sec_drv.h b/drivers/crypto/hisilicon/sec/sec_drv.h
> deleted file mode 100644
> index e2a50bf2234b..000000000000
> --- a/drivers/crypto/hisilicon/sec/sec_drv.h
> +++ /dev/null
> @@ -1,428 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/* Copyright (c) 2016-2017 HiSilicon Limited. */
> -
> -#ifndef _SEC_DRV_H_
> -#define _SEC_DRV_H_
> -
> -#include <crypto/algapi.h>
> -#include <linux/kfifo.h>
> -
> -#define SEC_MAX_SGE_NUM			64
> -#define SEC_HW_RING_NUM			3
> -
> -#define SEC_CMD_RING			0
> -#define SEC_OUTORDER_RING		1
> -#define SEC_DBG_RING			2
> -
> -/* A reasonable length to balance memory use against flexibility */
> -#define SEC_QUEUE_LEN			512
> -
> -#define SEC_MAX_SGE_NUM   64
> -
> -struct sec_bd_info {
> -#define SEC_BD_W0_T_LEN_M			GENMASK(4, 0)
> -#define SEC_BD_W0_T_LEN_S			0
> -
> -#define SEC_BD_W0_C_WIDTH_M			GENMASK(6, 5)
> -#define SEC_BD_W0_C_WIDTH_S			5
> -#define   SEC_C_WIDTH_AES_128BIT		0
> -#define   SEC_C_WIDTH_AES_8BIT		1
> -#define   SEC_C_WIDTH_AES_1BIT		2
> -#define   SEC_C_WIDTH_DES_64BIT		0
> -#define   SEC_C_WIDTH_DES_8BIT		1
> -#define   SEC_C_WIDTH_DES_1BIT		2
> -
> -#define SEC_BD_W0_C_MODE_M			GENMASK(9, 7)
> -#define SEC_BD_W0_C_MODE_S			7
> -#define   SEC_C_MODE_ECB			0
> -#define   SEC_C_MODE_CBC			1
> -#define   SEC_C_MODE_CTR			4
> -#define   SEC_C_MODE_CCM			5
> -#define   SEC_C_MODE_GCM			6
> -#define   SEC_C_MODE_XTS			7
> -
> -#define SEC_BD_W0_SEQ				BIT(10)
> -#define SEC_BD_W0_DE				BIT(11)
> -#define SEC_BD_W0_DAT_SKIP_M			GENMASK(13, 12)
> -#define SEC_BD_W0_DAT_SKIP_S			12
> -#define SEC_BD_W0_C_GRAN_SIZE_19_16_M		GENMASK(17, 14)
> -#define SEC_BD_W0_C_GRAN_SIZE_19_16_S		14
> -
> -#define SEC_BD_W0_CIPHER_M			GENMASK(19, 18)
> -#define SEC_BD_W0_CIPHER_S			18
> -#define   SEC_CIPHER_NULL			0
> -#define   SEC_CIPHER_ENCRYPT			1
> -#define   SEC_CIPHER_DECRYPT			2
> -
> -#define SEC_BD_W0_AUTH_M			GENMASK(21, 20)
> -#define SEC_BD_W0_AUTH_S			20
> -#define   SEC_AUTH_NULL				0
> -#define   SEC_AUTH_MAC				1
> -#define   SEC_AUTH_VERIF			2
> -
> -#define SEC_BD_W0_AI_GEN			BIT(22)
> -#define SEC_BD_W0_CI_GEN			BIT(23)
> -#define SEC_BD_W0_NO_HPAD			BIT(24)
> -#define SEC_BD_W0_HM_M				GENMASK(26, 25)
> -#define SEC_BD_W0_HM_S				25
> -#define SEC_BD_W0_ICV_OR_SKEY_EN_M		GENMASK(28, 27)
> -#define SEC_BD_W0_ICV_OR_SKEY_EN_S		27
> -
> -/* Multi purpose field - gran size bits for send, flag for recv */
> -#define SEC_BD_W0_FLAG_M			GENMASK(30, 29)
> -#define SEC_BD_W0_C_GRAN_SIZE_21_20_M		GENMASK(30, 29)
> -#define SEC_BD_W0_FLAG_S			29
> -#define SEC_BD_W0_C_GRAN_SIZE_21_20_S		29
> -
> -#define SEC_BD_W0_DONE				BIT(31)
> -	u32 w0;
> -
> -#define SEC_BD_W1_AUTH_GRAN_SIZE_M		GENMASK(21, 0)
> -#define SEC_BD_W1_AUTH_GRAN_SIZE_S		0
> -#define SEC_BD_W1_M_KEY_EN			BIT(22)
> -#define SEC_BD_W1_BD_INVALID			BIT(23)
> -#define SEC_BD_W1_ADDR_TYPE			BIT(24)
> -
> -#define SEC_BD_W1_A_ALG_M			GENMASK(28, 25)
> -#define SEC_BD_W1_A_ALG_S			25
> -#define   SEC_A_ALG_SHA1			0
> -#define   SEC_A_ALG_SHA256			1
> -#define   SEC_A_ALG_MD5				2
> -#define   SEC_A_ALG_SHA224			3
> -#define   SEC_A_ALG_HMAC_SHA1			8
> -#define   SEC_A_ALG_HMAC_SHA224			10
> -#define   SEC_A_ALG_HMAC_SHA256			11
> -#define   SEC_A_ALG_HMAC_MD5			12
> -#define   SEC_A_ALG_AES_XCBC			13
> -#define   SEC_A_ALG_AES_CMAC			14
> -
> -#define SEC_BD_W1_C_ALG_M			GENMASK(31, 29)
> -#define SEC_BD_W1_C_ALG_S			29
> -#define   SEC_C_ALG_DES				0
> -#define   SEC_C_ALG_3DES			1
> -#define   SEC_C_ALG_AES				2
> -
> -	u32 w1;
> -
> -#define SEC_BD_W2_C_GRAN_SIZE_15_0_M		GENMASK(15, 0)
> -#define SEC_BD_W2_C_GRAN_SIZE_15_0_S		0
> -#define SEC_BD_W2_GRAN_NUM_M			GENMASK(31, 16)
> -#define SEC_BD_W2_GRAN_NUM_S			16
> -	u32 w2;
> -
> -#define SEC_BD_W3_AUTH_LEN_OFFSET_M		GENMASK(9, 0)
> -#define SEC_BD_W3_AUTH_LEN_OFFSET_S		0
> -#define SEC_BD_W3_CIPHER_LEN_OFFSET_M		GENMASK(19, 10)
> -#define SEC_BD_W3_CIPHER_LEN_OFFSET_S		10
> -#define SEC_BD_W3_MAC_LEN_M			GENMASK(24, 20)
> -#define SEC_BD_W3_MAC_LEN_S			20
> -#define SEC_BD_W3_A_KEY_LEN_M			GENMASK(29, 25)
> -#define SEC_BD_W3_A_KEY_LEN_S			25
> -#define SEC_BD_W3_C_KEY_LEN_M			GENMASK(31, 30)
> -#define SEC_BD_W3_C_KEY_LEN_S			30
> -#define   SEC_KEY_LEN_AES_128			0
> -#define   SEC_KEY_LEN_AES_192			1
> -#define   SEC_KEY_LEN_AES_256			2
> -#define   SEC_KEY_LEN_DES			1
> -#define   SEC_KEY_LEN_3DES_3_KEY		1
> -#define   SEC_KEY_LEN_3DES_2_KEY		3
> -	u32 w3;
> -
> -	/* W4,5 */
> -	union {
> -		u32 authkey_addr_lo;
> -		u32 authiv_addr_lo;
> -	};
> -	union {
> -		u32 authkey_addr_hi;
> -		u32 authiv_addr_hi;
> -	};
> -
> -	/* W6,7 */
> -	u32 cipher_key_addr_lo;
> -	u32 cipher_key_addr_hi;
> -
> -	/* W8,9 */
> -	u32 cipher_iv_addr_lo;
> -	u32 cipher_iv_addr_hi;
> -
> -	/* W10,11 */
> -	u32 data_addr_lo;
> -	u32 data_addr_hi;
> -
> -	/* W12,13 */
> -	u32 mac_addr_lo;
> -	u32 mac_addr_hi;
> -
> -	/* W14,15 */
> -	u32 cipher_destin_addr_lo;
> -	u32 cipher_destin_addr_hi;
> -};
> -
> -enum sec_mem_region {
> -	SEC_COMMON = 0,
> -	SEC_SAA,
> -	SEC_NUM_ADDR_REGIONS
> -};
> -
> -#define SEC_NAME_SIZE				64
> -#define SEC_Q_NUM				16
> -
> -
> -/**
> - * struct sec_queue_ring_cmd - store information about a SEC HW cmd ring
> - * @used: Local counter used to cheaply establish if the ring is empty.
> - * @lock: Protect against simultaneous adjusting of the read and write pointers.
> - * @vaddr: Virtual address for the ram pages used for the ring.
> - * @paddr: Physical address of the dma mapped region of ram used for the ring.
> - * @callback: Callback function called on a ring element completing.
> - */
> -struct sec_queue_ring_cmd {
> -	atomic_t used;
> -	struct mutex lock;
> -	struct sec_bd_info *vaddr;
> -	dma_addr_t paddr;
> -	void (*callback)(struct sec_bd_info *resp, void *ctx);
> -};
> -
> -struct sec_debug_bd_info;
> -struct sec_queue_ring_db {
> -	struct sec_debug_bd_info *vaddr;
> -	dma_addr_t paddr;
> -};
> -
> -struct sec_out_bd_info;
> -struct sec_queue_ring_cq {
> -	struct sec_out_bd_info *vaddr;
> -	dma_addr_t paddr;
> -};
> -
> -struct sec_dev_info;
> -
> -enum sec_cipher_alg {
> -	SEC_C_DES_ECB_64,
> -	SEC_C_DES_CBC_64,
> -
> -	SEC_C_3DES_ECB_192_3KEY,
> -	SEC_C_3DES_ECB_192_2KEY,
> -
> -	SEC_C_3DES_CBC_192_3KEY,
> -	SEC_C_3DES_CBC_192_2KEY,
> -
> -	SEC_C_AES_ECB_128,
> -	SEC_C_AES_ECB_192,
> -	SEC_C_AES_ECB_256,
> -
> -	SEC_C_AES_CBC_128,
> -	SEC_C_AES_CBC_192,
> -	SEC_C_AES_CBC_256,
> -
> -	SEC_C_AES_CTR_128,
> -	SEC_C_AES_CTR_192,
> -	SEC_C_AES_CTR_256,
> -
> -	SEC_C_AES_XTS_128,
> -	SEC_C_AES_XTS_256,
> -
> -	SEC_C_NULL,
> -};
> -
> -/**
> - * struct sec_alg_tfm_ctx - hardware specific tranformation context
> - * @cipher_alg: Cipher algorithm enabled include encryption mode.
> - * @key: Key storage if required.
> - * @pkey: DMA address for the key storage.
> - * @req_template: Request template to save time on setup.
> - * @queue: The hardware queue associated with this tfm context.
> - * @lock: Protect key and pkey to ensure they are consistent
> - * @auth_buf: Current context buffer for auth operations.
> - * @backlog: The backlog queue used for cases where our buffers aren't
> - * large enough.
> - */
> -struct sec_alg_tfm_ctx {
> -	enum sec_cipher_alg cipher_alg;
> -	u8 *key;
> -	dma_addr_t pkey;
> -	struct sec_bd_info req_template;
> -	struct sec_queue *queue;
> -	struct mutex lock;
> -	u8 *auth_buf;
> -	struct list_head backlog;
> -};
> -
> -/**
> - * struct sec_request - data associate with a single crypto request
> - * @elements: List of subparts of this request (hardware size restriction)
> - * @num_elements: The number of subparts (used as an optimization)
> - * @lock: Protect elements of this structure against concurrent change.
> - * @tfm_ctx: hardware specific context.
> - * @len_in: length of in sgl from upper layers
> - * @len_out: length of out sgl from upper layers
> - * @dma_iv: initialization vector - phsyical address
> - * @err: store used to track errors across subelements of this request.
> - * @req_base: pointer to base element of associate crypto context.
> - * This is needed to allow shared handling skcipher, ahash etc.
> - * @cb: completion callback.
> - * @backlog_head: list head to allow backlog maintenance.
> - *
> - * The hardware is limited in the maximum size of data that it can
> - * process from a single BD.  Typically this is fairly large (32MB)
> - * but still requires the complexity of splitting the incoming
> - * skreq up into a number of elements complete with appropriate
> - * iv chaining.
> - */
> -struct sec_request {
> -	struct list_head elements;
> -	int num_elements;
> -	struct mutex lock;
> -	struct sec_alg_tfm_ctx *tfm_ctx;
> -	int len_in;
> -	int len_out;
> -	dma_addr_t dma_iv;
> -	int err;
> -	struct crypto_async_request *req_base;
> -	void (*cb)(struct sec_bd_info *resp, struct crypto_async_request *req);
> -	struct list_head backlog_head;
> -};
> -
> -/**
> - * struct sec_request_el - A subpart of a request.
> - * @head: allow us to attach this to the list in the sec_request
> - * @req: hardware block descriptor corresponding to this request subpart
> - * @in: hardware sgl for input - virtual address
> - * @dma_in: hardware sgl for input - physical address
> - * @sgl_in: scatterlist for this request subpart
> - * @out: hardware sgl for output - virtual address
> - * @dma_out: hardware sgl for output - physical address
> - * @sgl_out: scatterlist for this request subpart
> - * @sec_req: The request which this subpart forms a part of
> - * @el_length: Number of bytes in this subpart. Needed to locate
> - * last ivsize chunk for iv chaining.
> - */
> -struct sec_request_el {
> -	struct list_head head;
> -	struct sec_bd_info req;
> -	struct sec_hw_sgl *in;
> -	dma_addr_t dma_in;
> -	struct scatterlist *sgl_in;
> -	struct sec_hw_sgl *out;
> -	dma_addr_t dma_out;
> -	struct scatterlist *sgl_out;
> -	struct sec_request *sec_req;
> -	size_t el_length;
> -};
> -
> -/**
> - * struct sec_queue - All the information about a HW queue
> - * @dev_info: The parent SEC device to which this queue belongs.
> - * @task_irq: Completion interrupt for the queue.
> - * @name: Human readable queue description also used as irq name.
> - * @ring: The several HW rings associated with one queue.
> - * @regs: The iomapped device registers
> - * @queue_id: Index of the queue used for naming and resource selection.
> - * @in_use: Flag to say if the queue is in use.
> - * @expected: The next expected element to finish assuming we were in order.
> - * @uprocessed: A bitmap to track which OoO elements are done but not handled.
> - * @softqueue: A software queue used when chaining requirements prevent direct
> - *   use of the hardware queues.
> - * @havesoftqueue: A flag to say we have a queues - as we may need one for the
> - *   current mode.
> - * @queuelock: Protect the soft queue from concurrent changes to avoid some
> - *   potential loss of data races.
> - * @shadow: Pointers back to the shadow copy of the hardware ring element
> - *   need because we can't store any context reference in the bd element.
> - */
> -struct sec_queue {
> -	struct sec_dev_info *dev_info;
> -	int task_irq;
> -	char name[SEC_NAME_SIZE];
> -	struct sec_queue_ring_cmd ring_cmd;
> -	struct sec_queue_ring_cq ring_cq;
> -	struct sec_queue_ring_db ring_db;
> -	void __iomem *regs;
> -	u32 queue_id;
> -	bool in_use;
> -	int expected;
> -
> -	DECLARE_BITMAP(unprocessed, SEC_QUEUE_LEN);
> -	DECLARE_KFIFO_PTR(softqueue, typeof(struct sec_request_el *));
> -	bool havesoftqueue;
> -	spinlock_t queuelock;
> -	void *shadow[SEC_QUEUE_LEN];
> -};
> -
> -/**
> - * struct sec_hw_sge: Track each of the 64 element SEC HW SGL entries
> - * @buf: The IOV dma address for this entry.
> - * @len: Length of this IOV.
> - * @pad: Reserved space.
> - */
> -struct sec_hw_sge {
> -	dma_addr_t buf;
> -	unsigned int len;
> -	unsigned int pad;
> -};
> -
> -/**
> - * struct sec_hw_sgl: One hardware SGL entry.
> - * @next_sgl: The next entry if we need to chain dma address. Null if last.
> - * @entry_sum_in_chain: The full count of SGEs - only matters for first SGL.
> - * @entry_sum_in_sgl: The number of SGEs in this SGL element.
> - * @flag: Unused in skciphers.
> - * @serial_num: Unsued in skciphers.
> - * @cpuid: Currently unused.
> - * @data_bytes_in_sgl: Count of bytes from all SGEs in this SGL.
> - * @next: Virtual address used to stash the next sgl - useful in completion.
> - * @reserved: A reserved field not currently used.
> - * @sge_entries: The (up to) 64 Scatter Gather Entries, representing IOVs.
> - * @node: Currently unused.
> - */
> -struct sec_hw_sgl {
> -	dma_addr_t next_sgl;
> -	u16 entry_sum_in_chain;
> -	u16 entry_sum_in_sgl;
> -	u32 flag;
> -	u64 serial_num;
> -	u32 cpuid;
> -	u32 data_bytes_in_sgl;
> -	struct sec_hw_sgl *next;
> -	u64 reserved;
> -	struct sec_hw_sge  sge_entries[SEC_MAX_SGE_NUM];
> -	u8 node[16];
> -};
> -
> -struct dma_pool;
> -
> -/**
> - * struct sec_dev_info: The full SEC unit comprising queues and processors.
> - * @sec_id: Index used to track which SEC this is when more than one is present.
> - * @num_saas: The number of backed processors enabled.
> - * @regs: iomapped register regions shared by whole SEC unit.
> - * @dev_lock: Protects concurrent queue allocation / freeing for the SEC.
> - * @queues: The 16 queues that this SEC instance provides.
> - * @dev: Device pointer.
> - * @hw_sgl_pool: DMA pool used to mimise mapping for the scatter gather lists.
> - */
> -struct sec_dev_info {
> -	int sec_id;
> -	int num_saas;
> -	void __iomem *regs[SEC_NUM_ADDR_REGIONS];
> -	struct mutex dev_lock;
> -	int queues_in_use;
> -	struct sec_queue queues[SEC_Q_NUM];
> -	struct device *dev;
> -	struct dma_pool *hw_sgl_pool;
> -};
> -
> -int sec_queue_send(struct sec_queue *queue, struct sec_bd_info *msg, void *ctx);
> -bool sec_queue_can_enqueue(struct sec_queue *queue, int num);
> -int sec_queue_stop_release(struct sec_queue *queue);
> -struct sec_queue *sec_queue_alloc_start_safe(void);
> -bool sec_queue_empty(struct sec_queue *queue);
> -
> -/* Algorithm specific elements from sec_algs.c */
> -void sec_alg_callback(struct sec_bd_info *resp, void *ctx);
> -int sec_algs_register(void);
> -void sec_algs_unregister(void);
> -
> -#endif /* _SEC_DRV_H_ */
> 
