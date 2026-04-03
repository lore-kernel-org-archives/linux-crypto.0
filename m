Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E292A3A1A3C;
	Fri,  3 Apr 2026 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775209770; cv=fail; b=g0uSbHFau7v1egL+o9Jloa8E4FnteO0fVpJtOtG3kuctdCDkwdkCjILf5ejNLnN8kXeHiASB9tViEEU2yTpPoP65AsVItG7c6hugym2h34W/ZlnagYLvyrhecm2BBsCkp9zAmB+Vv/BDUokDOILkEG1Wirpe4XD7ei6ktn8EC0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775209770; c=relaxed/simple;
	bh=PEz0S4bktCAze1+PMRhP74N5Cya+R6A+5PthP2CU7Xg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GT+NOhOmdtnWIVbrMBNaVJFwaiC1sbbBkYQ5K8KEMtY6m+8O1Dp2uAvp4VsD8OVwPGXCmyrdM6zD07vHV0SltBWrYiw2lhJyjjzybJZ2GeX6tdrzyfz4V3fZJc8lgKCC7pi7lsCnkO6HwwD5JXdWLlc3LcRYYGkzbCcWkMvn+H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synopsys.com; spf=pass smtp.mailfrom=synopsys.com; dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=l+A4I4A3; dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=ZY1qFsy6; dkim=fail (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=cikU7fCc reason="signature verification failed"; arc=fail smtp.client-ip=148.163.156.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synopsys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="l+A4I4A3";
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="ZY1qFsy6";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="cikU7fCc"
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
	by mx0a-00230701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6335YBmx1080819;
	Fri, 3 Apr 2026 02:49:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfptdkimsnps;
	 bh=PEz0S4bktCAze1+PMRhP74N5Cya+R6A+5PthP2CU7Xg=; b=l+A4I4A37WkB
	66Cez0l8IY+XdBK3HfwPoBlZknZzjhl+x7jKwfQoH7YUh3KJccwkGyohvDUgzD34
	FThqo5MwVo/LmDFnt7fyQy1bLx6OFSPOvUCAO307ezeMzJdxjqKgCm5L255IrqrH
	kK7OEc7muzN7yqBfexjmn2OxdcrNWZ96dljdCgirLGgtaJxiAC71K6SIZBQKfPUO
	fNi4t3LlmhUiF8GMwJRB2QM6xpjLgrdr3yXWuDgFYqsuc9fpzuu5m/5ahf0AwIi1
	0Y3r47w/GDy5R098vpZaSPnX+xxzKVLlhbGKxlUonDaZGumk3Z9gKg5oLVxTeWsH
	9MYdtE2Sng==
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
	by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 4da7h3h04a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 02:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1775209739; bh=PEz0S4bktCAze1+PMRhP74N5Cya+R6A+5PthP2CU7Xg=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=ZY1qFsy6i1l4FEJcs9l7Fb83FXE4eXJOX9AQa4lHexlDVM2cgNyHswUGBzg1967Zi
	 c6eBC7WIarXnUXLPcaL0cwULstdy8QqJh0XK1xKo7T87q5DZtV7UJYXAbJ+eEZJRw5
	 qqZM1vsyO/2y8Lu6bqW2VtCg/lVYBwuEt0oQ22dX7iVWNO1K4G+zXSPAxCDNSLzBCe
	 lVA/XQOqapVZ46xpuS4M3FazunzkxFtfK5bdKm1/ELQvXs78Z5++IZQV8066a5V0h9
	 m783rQOlkYyALHa6AnWV9T5JdBeh7u6KZuvhxOeBMABY+5rl9Xbn020BS7S9pywOpK
	 JWITo2hqesiIw==
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5C4514010F;
	Fri,  3 Apr 2026 09:48:59 +0000 (UTC)
Received: from o365relay-in.synopsys.com (sv2-o365relay5.synopsys.com [10.202.1.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "o365relay-in.synopsys.com", Issuer "Sectigo Public Server Authentication CA OV R36" (not verified))
	by mailhost.synopsys.com (Postfix) with ESMTPS id EAF9DA0270;
	Fri,  3 Apr 2026 09:48:58 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=cikU7fCc;
	dkim-atps=neutral
Received: from CO1PR08CU001.outbound.protection.outlook.com (mail-co1pr08cu00106.outbound.protection.outlook.com [40.93.10.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id B03DF22025A;
	Fri,  3 Apr 2026 09:48:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WWgfXYHAY3DQizkkswxa3DhxR6wVljt9gKxfU0bMuHHtILOcqr6zA8mstmjCNndEEKjLToTTHRyNSBrLnS040/nr8BnlyX/c+aGNh1lDSEyGmJCIxRaDQNfxP8SqCcNpBEFX12zPfXs3pIRcOUypLj/J+m4Y4f8m8Qn6NpJedj/OlxZvmBwqQ3B5P0AYQr5HQHH9CVoyrOOQqxfUUzRoXOph4V4XVfhCBCmKl/oVZvA8io8issZrR4fNP/pNQG+QOS2nz0HMyEh5t0US3JiXi8a77ShVcClTuKgRpFf/23YECJYYTIggBAW1v5uT65Maqo5ehUW7Ri0mR6UKZya/JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEz0S4bktCAze1+PMRhP74N5Cya+R6A+5PthP2CU7Xg=;
 b=Bsv/xcBV1mAJeyxCe4D7aYuz6DbYrn6VtQCrqKWIWbAXVQTjwSDBEXw+e7g4qBe5asZ+jwiqqd5R6EiUuSajFb2kSn+RX9zDZ3pR0ifm9gCNcOKu0MpQKoz9K9/okMGJpNZlV5VOhnnbE2hGHRLCu2UEsBo0mHfBqMWhwTbrGLzBb72X7ltdBdxCbhXeM9eu0NxLJrdxiGXh6gEfpUxatgMIAz+AjbiSsW1nAMK1VqAry9NnS0ZHIVB29VoLCQz1N8Oh5SKupY3upaXAJTB4UvFUSBR+i/QmNWzFO9ALhm2KKUeSoA9l5yboOVMdDb/2KDQIw7yLbIAJpqn/+yeTHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEz0S4bktCAze1+PMRhP74N5Cya+R6A+5PthP2CU7Xg=;
 b=cikU7fCcQ0sDGUxQtFWE3Efb+JuoBXmvYv29//qtho4jwVpTn3FD6L0sqeBElgE6XE65O8CQPHIEpSjIag+u2fQP8kfyzoXDqCchGYQHnR88lH8Ig/XCOBlcbSLzi0DfI8mifBoddZerDPcuZdbEMosqFNf2at4bKFRYaTHgmy4=
Received: from SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16)
 by CH3PR12MB7761.namprd12.prod.outlook.com (2603:10b6:610:153::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 09:48:52 +0000
Received: from SA3PR12MB7997.namprd12.prod.outlook.com
 ([fe80::86e3:e992:17a0:7e95]) by SA3PR12MB7997.namprd12.prod.outlook.com
 ([fe80::86e3:e992:17a0:7e95%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 09:48:51 +0000
X-SNPS-Relay: synopsys.com
From: Ruud Derwig <Ruud.Derwig@synopsys.com>
To: Tony He <huangya90@gmail.com>
CC: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "robh@kernel.org" <robh@kernel.org>,
        "conor+dt@kernel.org"
	<conor+dt@kernel.org>,
        "manjunath.hadli@vayavyalabs.com"
	<manjunath.hadli@vayavyalabs.com>,
        "adityak@vayavyalabs.com"
	<adityak@vayavyalabs.com>,
        "navami.telsang@vayavyalabs.com"
	<navami.telsang@vayavyalabs.com>,
        "bhoomikak@vayavyalabs.com"
	<bhoomikak@vayavyalabs.com>
Subject: Re: [PATCH v11 0/4] crypto: spacc - Add SPAcc Crypto Driver
Thread-Topic: [PATCH v11 0/4] crypto: spacc - Add SPAcc Crypto Driver
Thread-Index: AQHctqd3Q9ZwrvGx6EmKsbCzEgD1gbXM0i+AgAA8vw2AAA1hAIAAEZha
Date: Fri, 3 Apr 2026 09:48:51 +0000
Message-ID:
 <SA3PR12MB79971109A59221A232AD19EECF5EA@SA3PR12MB7997.namprd12.prod.outlook.com>
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
 <CAAUX2SVmu+_Avs=6ipdJY9iciig4w6DzGNGaH_ZQf+LNqR=KVA@mail.gmail.com>
 <SA3PR12MB7997CAA00BEFD7402AC63DD7CF5EA@SA3PR12MB7997.namprd12.prod.outlook.com>
 <CAAUX2SX3wjsj8JLkej4oKR=77BQK2AEmc2tAqe8eCJqO=gaizg@mail.gmail.com>
In-Reply-To:
 <CAAUX2SX3wjsj8JLkej4oKR=77BQK2AEmc2tAqe8eCJqO=gaizg@mail.gmail.com>
Accept-Language: en-US, nl-NL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR12MB7997:EE_|CH3PR12MB7761:EE_
x-ms-office365-filtering-correlation-id: dba1f795-c418-474b-0657-08de91663622
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 1UvKp2+bTBvUoOtRTynCd12DFRFpjLgIaUhS07pk+r/q7f/XJgwJlxdmu2X9pQev3BMTidenN1sc74e9O3Nnf57FB388IWFe/LP2Ujxsfe+KrvDvkriyolnXYxvcn5Wx10Qu0vrQKeMI8cHOhmSkZUp3mKNbBcmf8XOLzfAl/Vg+riwlFmWKGgCOr5Iquak/y1f1gjtbUhVXov9e6YFlJvwGQAdHMkRxlTt3v48CXMBYu/Y47PhoY3Q6lY6ePSzj7bIU+9CzZjNFdr6+uxDA6JHpQd1EoavMDXfwgjfOm5rC6orPGd21UrD+MH51CAYw6t5MUFyLFx/maDohlwxU6/ePU9tpfgrJejDnjZSjC9yt5+AQ6syoQc2ZOhHfZDhKM6NZru2Vn++6Tn5Ntot06tWp1HIKejsEgUi0aaEo8s1HXneUfSGcOw5eOx1hrpASQd0VBaJu1fLesDxuMCcoxizJw9KOdvvyPDFRt4e5CYh7JXEMMO32qp78Yh/wogl52Gz9mRUw3y1bx4MgQFbowq0ZIsXkXGMw3QwLtSIkXF5SaUP+R8hOKX3z9bwhZiv6I+qIvwDoWKW+7WYxbyW0wVrUDnv/ZqWIRGhOcuVPOSLrCjtophZZ0Rcufh65SpVIy74/sE25e4jxTq8CTe2HwDroKctm9lTucGUoB/rRbRVTYEeVdxYCGIHdlSK+cbbFbR2Z9LIYxeHP3ovUoXxZXqMTYIp0SLn9kJ8UFVhmlbUj+ELYs/H/9nVn+pgyCzlLECQ3RTlhiNijJHeFJVm3eTY9k0Wp/EKybux62lCFRzM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7997.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?TXXvHmZpA77cgw3G3qtT3mz8c4XHVTIGECCSngY98yx+dIyezbGraEhfob?=
 =?iso-8859-1?Q?CIjcoAbwsELO8UjJYE7qWIQpxNCleDQ4wxi0l7uGA0ifRU3+4R8HEj3bVE?=
 =?iso-8859-1?Q?idY82Ltu/tj59OHhy35PjWh+h/ZqdLs5OeFC+kGrScxTTAGC23LWS+m6wC?=
 =?iso-8859-1?Q?iUzRi6CZSG7w65eA5/G6kiPfG+JA23GEP3lllDZDOuoTjB+JtulbAVcczV?=
 =?iso-8859-1?Q?I7nGeJaDgiN/4MYzNP4hfRlnXOJVlyxSjWjAa56bIMxqTGCG2yfPbPr7qS?=
 =?iso-8859-1?Q?/l/eFNq5tBjySMijtC0y/y/E1KcXfbdvm5JAxcnChmXkw/8Pmk3Z1tNDeD?=
 =?iso-8859-1?Q?5J1Ef2N6V/3yWqoUUYiI3DjYI2/LWhSthN93ZBE3qZDVtkyQKZ33sEfxxb?=
 =?iso-8859-1?Q?Z6/+6Xbngt2FeKY4XbIykgChhfsOZDtMCTYgJ5uISi7kGiqwl9B6wtBXP8?=
 =?iso-8859-1?Q?nH+T0MljReEjcsnUMqV1wf9BiqzUjbckAO7TCp2EB3gUMSn54BzXVPBf0b?=
 =?iso-8859-1?Q?VDao1R4/YAhBJJnSWXCu8lNttn3nIiT4G//9ScVJ5HNFOF9WRABEStRwU1?=
 =?iso-8859-1?Q?V5JYW1jI3bh/zogBw7ZLoZyI2aONo2gKsRLve7h9wQ4WiUCzQ6veOJSQod?=
 =?iso-8859-1?Q?XSnbEoBuFLSuZ0hr7d/O/BqG/Qy2+2iupXBNHB/603qiq2qfEZ2L9SErNS?=
 =?iso-8859-1?Q?6cXpVVkj+mQ6wEiB54K7CL5GWjzjX/+YcnGQfxTreRtaFPALhBmszPnQ7c?=
 =?iso-8859-1?Q?ny8bcFyfECck/cxcqv3jN1y3FqG9zx4sEQO7p0pgDTbIJ6yI3D1dwzkI8j?=
 =?iso-8859-1?Q?SrXcCZP5Sryn69XEciaYPZfa+SbIkVgtICKUnSbmXOnQ28wgAFoXmQ1w5C?=
 =?iso-8859-1?Q?D1vY2lL5nzFTnQEMw6LENP+PRvxPtlwErtwTi8liNlXuf7qharr3YthrTH?=
 =?iso-8859-1?Q?0B/DtvEP6qJEm871TMdYuL/jUg1CC5EPASIVb0gX2lpJg1sfSSVAqjJc0L?=
 =?iso-8859-1?Q?LZDTUzbuBtietnZqImWOoSXwCXz2IhKCIuYWjHqyRyPUKU8Md57iZvTnVG?=
 =?iso-8859-1?Q?APy9qH521rQ/FW+Dw7G2LBp0nPJeb229m3y7UAE59lL6VtImamm/WYMQdc?=
 =?iso-8859-1?Q?Y7MYHvTnkl0WLsdaXvHzaq7NksPqqesApvIuo29reL3/7sAgNmeecFcSHq?=
 =?iso-8859-1?Q?8RoaIJGfm1Gg/bnME4CSei/2lfrAQBQ7McpWqmBL5k591BCBrSGRCAwxTT?=
 =?iso-8859-1?Q?0+eqU0ziClJSV2yHOodfPr9f9Zcs1UX8ZTW/8Zcox8dHenFgRFjk8C4v6/?=
 =?iso-8859-1?Q?yv7sbzf8L1CuKuoP+4XNhtP3GTEk5TOVPVTj9T0ukIZ39561zX8l5Ds4Bi?=
 =?iso-8859-1?Q?CSvCjnmuOKkf80C/hVLzaeiYdxaJk4CRTsrHZjOoHY4QBY1Fq8huWKTphD?=
 =?iso-8859-1?Q?2Htcx5zJ5kQPvgw5w1ywA867KoR+zIv4JeEuA3ExRwvHVbxJODg81QsS+T?=
 =?iso-8859-1?Q?2sgLOe4s6OKCLLrNCChIc0wkzfctHiydcboTVE+RL36/brVGLOQdYQwKv4?=
 =?iso-8859-1?Q?VE8Z1fm+7xFEhiyF8n7ZQWiPagjVf9kiJo6uzwRM8HborbrkDoTzQy2MA7?=
 =?iso-8859-1?Q?3sUudKiqQcqbIBBibnpG6/XSOZxXfhhU1m95doOd9pJMSLp4A9q7TpaWcx?=
 =?iso-8859-1?Q?ez0T1n262scW3afdfpALD7PpGXf3kEHEmibv++TOCdxU6PUfilbsxfJpVM?=
 =?iso-8859-1?Q?TArDs+ZCyNn0xAHo21fc31yzO9buFg8aNl9AHfhYwVcddP+RIYDvIQ6xnP?=
 =?iso-8859-1?Q?oNhJm94/gg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	cDKhZSD89OqWWzGf2m8jTa97lB+i/Ex74Nn8yMpThgx3C+7seOAeEpMK+W64fjWSxq4reUHpjgdDyN/lOb670upYn331JUEDREMDgDqs0x1wyGO2YQ449ELvAdwRPnktvu3rPZrPsEEABwxZdGZUyGj17WXF8mAdo6/1zEn6jQZZdOmWRi4aXlMG92MftrTA4R9X6dg1eMeDTpP0GAQukHWuje2y0Cue/098kxpuVDrQaT1ISAd934rokUxkCdzwT8JzuYF2NPscuQzaLnxOvX1j8i6BpwbNaLWWBUAGAwqzFQ8mcEC5PLLmQ4yNxgP8WfKi33Q8q99klFtNLDYopg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Iomjrs649e/TAfOrNvNznxFYddmOPD14ayQmpkr7EIwpRwrvY3ee+k1yor8ZAXLxLijImjl5m4oUt2R9Boy0YINcpczGMaDgp822XVgUlMWClpsXE7+EjGahysp8X5gIpIVUAB5/jyvYhEDBXjOb6iLQUHTnfQr0aqbiw7Tax+HTrGDoDgL7DaTJmqkNPipxVxBL++d+7ONZr6++VqnqW2IHzwQ0SAqla3GMRUKKeG8QbtG9kWJkoIXwOvf5s9wGP1NhhBsVvvyRaTKDWxqHp1f14FHBNL/KgeYHHOKmFlpQ4RXHqF5UafQV25tGrJthaEaNjwZlolUyVebuYc4HitnGzSoG4msN1mekP88KRnUPaAZ/KFJWGME2AK+c0q5A73/37TF0OiLORTwDIUIHlwAtw6K9ZX9s716C/5FNjmngAIm1MwHBg7Mys9e+Qev3SJ0T14RC/aMxT8Hq4NOY0JwmGyGoVUNYrZteACAjKBDzNHu3FTNMjM4ryXLT9TLktbAH0G2j6SAw0/i4FHFAX9UGLrtHQNjxAhGUVgo5cIkat+XUDTVSwSXfTvkQhZlnuLomQDzIl2Yv63RQzESxPyd0Q+xfb9QGiBO5XSAWM7C3P70shPP7VRNWPx5yC42g9lBTEobVYBuXStODedc0ew==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7997.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba1f795-c418-474b-0657-08de91663622
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2026 09:48:51.3430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgp4xiHf6cPP+SkO7S7bQhgde5S9XAm9ywXeA+5OWRRbgq7C0Wojenc2Q/y21Yaihpa7aEuFOwEnybxPTyQnTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7761
X-Authority-Analysis: v=2.4 cv=fLE0HJae c=1 sm=1 tr=0 ts=69cf8d0b cx=c_pps
 a=t4gDRyhI9k+KZ5gXRQysFQ==:117 a=t4gDRyhI9k+KZ5gXRQysFQ==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=A5OVakUREuEA:10 a=qPHU084jO2kA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tU_645BZ7FZt8VqRJtHG:22 a=xKlp24NoqlmsZ8y70KjX:22
 a=FTb-mtjGhq1A_d1Ai1kA:9 a=wPNLvfGTeEIA:10 a=zgiPjhLxNE0A:10
 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: y3UC_lCrrSBzXciVZJ89qOdqPFCAGpUM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDA4NiBTYWx0ZWRfX4pebKX6zLM2F
 f8kDJIyaUG/N4u/3M0501StFQP4Rgu0UWEZj7qeczNEoIg4DTOR1Z75WcsYAl3GbroPXw/up0Kw
 p5Zk1Wj4o31FSRNMcyHUbtqJX6FwNsnt1yQ0m3HbIOL/yIAzjvdYmTXDW+y5fMVaQC81LH7bcFG
 EexwjY0tCpCajqgB6RwgyL4LBa6uHu5a0AkGOaXFdjAhpbEAr81VrTm+TMZ0MUrXZEzg5qu9BI2
 9Q+/P7deg+2zIWuUDcCFXTm2/OiQQsMKvu+nCWxtlRVt6gJKwceUK2mywW0k/DAsnBtTYNZa+ki
 oeKF+Ius8SeCSqy8HbfuUQQk6uoOfR1t/HggKPQxQvjRcZsKixc3jtwpL3XkNVZdRI5cUJkyKoA
 pUtuc7Q3++hLugx79ZeuoagS9q7uZsB++h7bAqYy2BzQdz/1fOoY6I6XDy5tQE0YJr5M59jS2k6
 ruc2sHjSsrkJj2frMIw==
X-Proofpoint-GUID: y3UC_lCrrSBzXciVZJ89qOdqPFCAGpUM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_03,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam
 policy=outbound_active_cloned score=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 phishscore=0 suspectscore=0 clxscore=1015 classifier=typeunknown authscore=0
 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2603050001 definitions=main-2604030086

Hi Tony,=0A=
=0A=
> My concern is that the main bottleneck may not be the crypto=0A=
> throughput itself, but the per-packet overhead, such as=0A=
> ...=0A=
> Could you please confirm whether this understanding is correct?=0A=
=0A=
System performance depends on many factors, CPU speed, memory=0A=
architecture etc. Trade-off between packet size and overheads differ,=0A=
but indeed should be taken into account when deciding to offload or=0A=
not. Note that besides performance, other factors like security level=0A=
(e.g. side-channel attack resistance, key management), or functional=0A=
safety (automotive and other safety critical domains) should be=0A=
considered as well.=0A=
=0A=
Ruud.=
