Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013033.outbound.protection.outlook.com [40.107.159.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7098C319871;
	Wed,  9 Sep 2026 21:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788987796; cv=fail; b=tzuOb/AJ5Lc0kj13zSLLSCRcH5YQ0XPvl3t7gnf1hp+W7b2TdF7kKWYmph0Ymo2B5NrtMcQcNtojeY9Ay1A5IbMtN0Iw5E5W30cs3yKepecsTZ9GvPlhUCE+IAO6z3vpT9CZUIig8c7qbms4PDpYkndqDgwQ5+r2EM4QhUyIi00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788987796; c=relaxed/simple;
	bh=SfcaoJlgkIBTu7dNI7UrD8ziMhtSWNhgddsDbfv9iT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AjXxjS1JFPZj22+bcV6XHeLBk5bgPSlwOi+aPS1H6oZ3rcHU6APhS7d8mABe1pjpGFKmayLAm9vpcn1B3cQlrzEIcKCBKAUYvOfKchJ9vLndCOyqxg9zPwdQqflb5+7VUEr2cfxxF6Nx7ezcm5XSVdPkGWeBezpN9DplFqCAQiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=P0lF4h5L; arc=fail smtp.client-ip=40.107.159.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="P0lF4h5L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f7fxSVi921bRbp/1EtsIqtANDXUm2VQ9x9hm0UUZrR3rXteisUCqMl6Yhi+o/1a9jl3bkFRDKPQ5PGEqIaIANOFUH9nkDxza4dXJRURWh6iVxYUasSjeMwTq01tL10rABnsp4psbif0GNf6X+n+tO2+Zw9GrdnhtXqQBN3xdGW4brDqAqMXss6AkgBXvVBLuNct2cMdgOg89S9KLZ6Jc5Mx9HG/PIcTeZ51uwJHwTCmCORJDbTSsp+rmm2nEi6yX1hO/VbyDuZLJmIcsG7sctfBUuc6h/0T7y98OM+FmijbSrhXuvGOnpMHxJVwMyiY8kVrw/toLXgCMpB0r/mJ22Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FjJQxImiAzkLyG3uq3veFiggE+2UisuLKHUfG61M7w=;
 b=V5hruOxJaxGydrUF9GaL7KJJgsLXBZ/NdMuWGTwxTGzjq76ZNIvsIbZn9pK0Nx+qLtVGFqm53LwYBkD1vpTw4t8KjzohzC2xCv1xbh+am+/+O3vPqOeADF+ybDsciL1SaG205co0UjWLVlxKOABftnFkrfw91gseNVeKtSbGNCIBYbo0zM6o5ScxbHg3FoSm+NlpZbTNQLEr81oCq+0CKUrL61zsYWrjWE73UKlIsklh6VCX/+u2YrRXCHY8v6cTQi4Y/xO6//B54UBhJSWBiRA3zJkER0AmYuUetYQwMPrjNyTIOsPHFbLBQmIi+P3W+uil43fi3k+iJHt911+YcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FjJQxImiAzkLyG3uq3veFiggE+2UisuLKHUfG61M7w=;
 b=P0lF4h5Lo4hY8r4pKSqyu+IFPwEKGq5w5RhngsSQTeKntCDXjSMNy5RQDqWIVJnfK3Puz13z/d2W5EILDNvKo0OakYoy1Lyd/b084163JPQe+1IRuo5q/Go/DCd1aPGhafI1xBq7Qb8n3lt0OuKf3V06vYz8YQZD82lbRrqHzY0r8yaXknCahYItxq6BxfxZfU3cBij9XTpLMOD7bXbjPbYNTZverC/1Cl+dtqXq/VEU1fYZ4D3phssqhJGn2O24kPfx38qOsPsCK/ZcebGb5/9yvtDaSPpihvbulfKkGGMeIrOChy7Udei2SBoLWrNJQu519iwhvHrMRriwrplLOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM9PR04MB8969.eurprd04.prod.outlook.com (2603:10a6:20b:408::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 9 Sep 2026
 21:03:12 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 21:03:12 +0000
Date: Wed, 9 Sep 2026 16:03:02 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Radu Solea <radu.solea@nxp.com>,
	Franck LENORMAND <franck.lenormand@nxp.com>,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: mxs-dcp: handle zero-length skcipher requests
Message-ID: <aqHJhrSE2_pcCp8L@SMW015318>
References: <20260908094437.1548278-1-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908094437.1548278-1-lilinmao@kylinos.cn>
X-ClientProxiedBy: PH7PR17CA0060.namprd17.prod.outlook.com
 (2603:10b6:510:325::24) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM9PR04MB8969:EE_
X-MS-Office365-Filtering-Correlation-Id: 64fa9a19-886c-468b-32a8-08df0eb5c246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|19092799006|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	GVfcsQwz/nAQ36hOQup/+XmBmYvOV+NpevvtMGJfwlksHCDSiSF+OL9j2gW/HBhkKNXv8H9vFZQCzcRCgMai3DQtko/P+qncMfQ1/En0t0BVVRUXJtzXvvKtgvcTwmrvddvtzpubaPTAN8oh6cg6wqP0pDkJSHnVs9Vkj/1V+k9ptX24OjdMKsg/WOSXoI37hLep0e8nTaGQ8FmOhcUV/N+Y7dQFOZhKD+4rimWoNpvbXIkn4Px1DpX02c0VDiRQ+Hmc1LxmVEvlB0NqrZhJpey6n8/x6SHSWF/hazoSulFt3pfpgJzzcTysU4/C/WdeX6rtpjmwavH4mKJlnG5TkD+VZVJZYJvt5I4D8nheaEkYHvGAL8iC2aSbJcpceU1NtqQz4IkvarSIHa1M/C7dTkOUJTaBdrJfUESea8En9i8jdTfv1MeL0EPciQihrKWukrE3mKqZNwDls9Nh6LiswKIV1p4Rf+6tyHwAE1iTKii+tkqm7LZOYZCxmjrd0j6FRRX/CJBbbWvGO8VwzZpkwGEwJh+f5kv66R4yvnHW3UFrXk66hhHofmw2U5eMwakQcmCOTUa0oe5htnA+YCzKmyodYXUmTeC+LLp8RECLSbitW4bBwgfwo6fHHgaYwiMSkPqFcCrL+Y/IQuhlKHtHMQ+mejSc9OT9Pr4sore9Wmg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(19092799006)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fa/KsfOaj6E66YsT/C2Yp00b61jByx8U+zVMdJ4nVbd0WeFIf+4Gz/Wrm55H?=
 =?us-ascii?Q?mLopQVs1AAr35cCNINC2FERCF5xpgGYCKUjcpYO71DBz10l77/SZOd9Wd8JY?=
 =?us-ascii?Q?3tktktj0JJ0lki4FQibaXAZPECIkNwAXo03DKQ+zFMtg0zzh0ppTg5s3RPTK?=
 =?us-ascii?Q?Ou+dS1Ao1hmvjsGmvkMmBKmLQsKAKFkNA9e3du6dl//fv/DAwuYtW8emXYxI?=
 =?us-ascii?Q?mdBh4/5ANQUWBFzd9lVeS+csx6tGra03Whz/VmonNOIFAOhpifvmT7o5YOl1?=
 =?us-ascii?Q?7ND/xVpxt8Io9dBY+mMQHCv6knnpI4lADFcLLzfdoZTmruhY1Rl27rXW83sR?=
 =?us-ascii?Q?0Tfx6ctuBbNUIxCLu96qICXgn+4QVAt5wQHqjOHUFYpaAnBVMKE6isrqtqaN?=
 =?us-ascii?Q?gngchOOuDCUU83jlu5RvDH8tbJiaRgzdInfXU5ZuuiX+M9ZHryRUkVosoQyU?=
 =?us-ascii?Q?0KOfwxhXBqlt/uAv6ZgDJxsRQmiw+A7GN4DkTfQ9TC6q2uIP9ItHB7+iMMV3?=
 =?us-ascii?Q?pMS+n1ltLzs2CvYXNcB8OChwv0ISR5UqcXZa+SZWaQKB+ZGRnGmF5jGUSGJY?=
 =?us-ascii?Q?vAVcwHWnwAr09/o59hy1LIEp2vB+ZwjEznlp8K0S8jabW/izPjshU26ttDXX?=
 =?us-ascii?Q?zbCUgXWCqTWY74mO2YTq9bEQ4RyQnFxx/JssQKvmurjuDHeN0HntjqFIJHN3?=
 =?us-ascii?Q?a96ZdBpx7TDo4bPEcTe0/2i6/AsEDJwDBd4Ks4/NlLXDIrMmLYWzDIaEPdgF?=
 =?us-ascii?Q?jOh2EmjiZn+V3gLFt7/pLhEfPsm3gkIQuTAIBF/gU3vXjvjTX6S+T3+tK8z0?=
 =?us-ascii?Q?b9GeEVL7Bb14GQWOJmZnoN5nw1U81h+jUnMoXH4zY1yNSWCOeJNOHXYX/28n?=
 =?us-ascii?Q?J6NNAHhqsH0UI/mNdewQgIIBBabWoRzJtv8Wl0IH1F0NTN+GaOWChInaOXTF?=
 =?us-ascii?Q?y+vGcj5IOZVtMPrBlYdR8Wp8vTYcB42brwiZ0JOtH+qPjgjOyVHFWBV2/xsL?=
 =?us-ascii?Q?J2za0uEOY2CRkZM1kAoSGKEKxXr01YWXCNND7nhQNbK7jXtX9X+66ICRi8NO?=
 =?us-ascii?Q?gR+OQrFenqV9ZGx6VjY48WfpWW9QdnA0Vw2lGjPYupx/CZf+K5XOJMdQPIjU?=
 =?us-ascii?Q?zd85NMpFJSTejajd1X2fQ68W6evPyYh4G3vh68FyEFqHtRRiTk/kjrLnieRk?=
 =?us-ascii?Q?G20z/LQZH1mlXgDEiLv4Qz0+aWn9B+Cp//bYGWFdwRbLNh+zctt+VnUZlFHX?=
 =?us-ascii?Q?zZqyR0UuGnOJ5+aMktwP1llvIBDSxB7mweyUCiRwfu9KJ76xBX9qf1060YuN?=
 =?us-ascii?Q?ENjr9HowUBH5BKFPOmkBD0xle61p2tmYMHXhvPRElzD8J/1h7vtT8SovyVbH?=
 =?us-ascii?Q?56YvG8lpTD0vflGg6bTCpPiGonmVdHuMYwng3rhjZYt1A0fjDDH7hr2ItMZf?=
 =?us-ascii?Q?PZrdSTPWXRtaYkqgqluAmkrq84dxRIz+Lqp7EjTfgWH+zeWjn2rX069wKzD1?=
 =?us-ascii?Q?Gk7MNqf1KnF+KYi8H0POkzBC6kLvk7O9qaVe4CmEwvs73ONSmh0FAjCKakpS?=
 =?us-ascii?Q?c7MXoglUmZGFY34Pbm16/ASnV2qTeCuGp2QWqtDB3zCtGL3jm5HRTE16+ero?=
 =?us-ascii?Q?99xMlqCPLx7vNCtdAX3fT0gMmNIEWgWfLlm2Sj6l8mv1AqYFO3xpsXMdVhsy?=
 =?us-ascii?Q?2/6jsPyhSVCr4QCE6ur30xJhkfzSLldHrjKvFEe08gMjoSb83fbBEYONJ95t?=
 =?us-ascii?Q?gIsVznAmhNbdGaoNc/2j8bdF3P+Gw+2kzqM3ydZxQ297VJk8/NZ1?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64fa9a19-886c-468b-32a8-08df0eb5c246
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 21:03:12.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3H09etBTCCXlWAO9e2ZoLYGol691R2n9+rp0JHWY0JrNO1pyD9SaESygIvkzUIzFyKhvL4q8M4wApPMkXrEPiSMIr8GHBi/TAsyKpGeFUyfR5xI9WAugbz662ruMTKuf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8969

On Tue, Sep 08, 2026 at 05:44:37PM +0800, Linmao Li wrote:
> The generic ECB and CBC implementations return success for zero-length
> requests, but MXS-DCP queues them anyway. When such a request reaches
> the worker, last_out_len remains zero. The CBC completion path then
> subtracts AES_BLOCK_SIZE from this unsigned value when updating the IV,
> causing the offset to underflow. On decryption, the resulting source
> address precedes aes_in_buf.
>
> Return success before enqueueing zero-length requests, matching the
> generic implementations. This avoids the invalid source access and
> leaves the IV unchanged.
>
> Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

> v2: Clarify commit message: describe zero-length return-0 as existing
>     generic ECB/CBC behavior rather than a general API rule (Frank Li).
>  drivers/crypto/mxs-dcp.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index 133ebc998236..60794b4d49fa 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
>  	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
>  	int ret;
>
> +	if (!req->cryptlen)
> +		return 0;
> +
>  	if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
>  		return mxs_dcp_block_fallback(req, enc);
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> --
> 2.25.1
>
