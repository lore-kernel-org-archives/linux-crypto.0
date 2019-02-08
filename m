Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52DBC282C2
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 01:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 773602085A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 01:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="3BXHL6in"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfBHBHv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Feb 2019 20:07:51 -0500
Received: from mail-eopbgr800074.outbound.protection.outlook.com ([40.107.80.74]:26784
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726792AbfBHBHu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Feb 2019 20:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0yMjKttyloySBZ4dUYlvk5S+S0rmKMdwOBTxFPbqxA=;
 b=3BXHL6inJ1y/zFACsUCbzeHxTvPUKUPCMuENIUNwT88JTleYheNzOiDpVLirsxqPwidhnaLHUcjumDWlTzSXBmJXuFFklcRfkOoRqaxQHchvwM5s6k/iNwa+94h2OXuIop7EVHPxM6Thahe9I74SHmpixfWuHCfgRDLB3Xca3AE=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.38.138) by
 DM5PR12MB1628.namprd12.prod.outlook.com (10.172.40.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Fri, 8 Feb 2019 01:07:48 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::3165:79a0:3e5c:b8fe]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::3165:79a0:3e5c:b8fe%8]) with mapi id 15.20.1601.016; Fri, 8 Feb 2019
 01:07:48 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: ccp: fix the SEV probe in kexec boot path
Thread-Topic: [PATCH] crypto: ccp: fix the SEV probe in kexec boot path
Thread-Index: AQHUv0q0Cn/Bm/2EkUyIle1v1tq4vw==
Date:   Fri, 8 Feb 2019 01:07:48 +0000
Message-ID: <20190208010736.25744-1-gary.hook@amd.com>
References: <20190130205710.14268-1-brijesh.singh () amd ! com>
In-Reply-To: <20190130205710.14268-1-brijesh.singh () amd ! com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0065.namprd05.prod.outlook.com
 (2603:10b6:803:41::42) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR12MB1628;20:ScBMEEBPEBqiuryLSYyyBGBEjpoANlRDn+4ZGGnAU5YcNrr/ka6/zsacEIgDgVoysHF/6woddFlnTdK6YCezufwwiSkEyi//DfKEhbgsjlK4c0gxgto5p/S2bqMg49FWspkiSPw0Jdl96Irmns+LSYCYUNPgVg0PeMUdRSupvAi4nCxzxfTAT2EtOsjMo3/ZxAZ0IWCVK3bBi/3kka5bdXv4AFubRiOta9TaMQYVBapT3abn4D9SYYCx4q5ax4Q8
x-ms-office365-filtering-correlation-id: f748578f-f353-4a5a-6766-08d68d61d6fa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM5PR12MB1628;
x-ms-traffictypediagnostic: DM5PR12MB1628:
x-microsoft-antispam-prvs: <DM5PR12MB1628F122328516978963A340FD690@DM5PR12MB1628.namprd12.prod.outlook.com>
x-forefront-prvs: 094213BFEA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(366004)(136003)(199004)(189003)(478600001)(6512007)(102836004)(186003)(26005)(97736004)(86362001)(11926002)(5640700003)(6916009)(72206003)(8936002)(6486002)(316002)(50226002)(53936002)(2906002)(81156014)(386003)(8676002)(1076003)(305945005)(81166006)(7736002)(53546011)(6506007)(6436002)(2351001)(446003)(11346002)(66066001)(68736007)(14444005)(476003)(6116002)(99286004)(3846002)(106356001)(486006)(105586002)(2616005)(256004)(36756003)(2501003)(71190400001)(71200400001)(76176011)(14454004)(52116002)(25786009)(299355004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1628;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2GZwQD+lfPoMPBdEfbttLZcn7/6TqMD0/AszTJ4GiEqgN2fLbVluU2/KkbL0Iq6Htv7QaRpeJrJcKuEABHYukrXaPMGd69RCg5PV/askxIOOb/grFmA5AGVg7PcqjSeMuq60bRFIwKyzMHStqOG+/Fj+P1ep6clvGyb/5JntxbTWCrDU6cpETmfzEABEavb4HRyT5avMBlXcfbIpwUerRH/qdbkg0EB/TfKVax+6kLYLJf6xZS5/zcRLVriProKtic+8EeRhJ2oRDrk3QVv+N8VZUXcZaCsxJWpBQvAzphkBtdarZD3rM6d97N0xqEQmmFLXVOxsyGNAKtW1FTdOh4sKyh1AaMdA1UOcR90FnUqxwSM1JqgscAejHQ96lo4NqPBQSx8WyaScVw/Y0bUeIczWu7AQXHjeBIgpzHPx93w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f748578f-f353-4a5a-6766-08d68d61d6fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2019 01:07:47.6231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1628
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/30/19 2:57 PM, Singh, Brijesh wrote:
> A kexec reboot may leave the firmware in INIT or WORKING state.
> Currently, we issue PLATFORM_INIT command during the probe without
> checking the current state. The PLATFORM_INIT command fails if the
> FW is already in INIT state. Lets check the current state, if FW
> is not in UNINIT state then transition it to UNINIT before
> initializing or upgrading the FW.
>=20
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Gary Hook <gary.hook@amd.com>
> ---

Acked-by: Gary R Hook <gary.hook@amd.com>

>  drivers/crypto/ccp/psp-dev.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b16be8a11d92..966ca6f9cf79 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -437,6 +437,7 @@ static int sev_get_api_version(void)
>  	psp_master->api_major =3D3D status->api_major;
>  	psp_master->api_minor =3D3D status->api_minor;
>  	psp_master->build =3D3D status->build;
> +	psp_master->sev_state =3D3D status->state;
> =3D20
>  	return 0;
>  }
> @@ -964,6 +965,21 @@ void psp_pci_init(void)
>  	if (sev_get_api_version())
>  		goto err;
> =3D20
> +	/*
> +	 * If platform is not in UNINIT state then firmware upgrade and/or
> +	 * platform INIT command will fail. These command require UNINIT state.
> +	 *
> +	 * In a normal boot we should never run into case where the firmware
> +	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
> +	 * may not go through a typical shutdown sequence and may leave the
> +	 * firmware in INIT or WORKING state.
> +	 */
> +
> +	if (psp_master->sev_state !=3D3D SEV_STATE_UNINIT) {
> +		sev_platform_shutdown(NULL);
> +		psp_master->sev_state =3D3D SEV_STATE_UNINIT;
> +	}
> +
>  	if (SEV_VERSION_GREATER_OR_EQUAL(0, 15) &&
>  	    sev_update_firmware(psp_master->dev) =3D3D=3D3D 0)
>  		sev_get_api_version();
