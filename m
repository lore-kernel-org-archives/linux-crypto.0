Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3CF2F50;
	Mon,  2 Jun 2025 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748853005; cv=fail; b=p9lOg8GOvmsc3vYnADRXyymDZsxdr5sTRqgGXW5NzzA1wrSKwDBD5riwscX2N+9j6Qmmay95U773so0Wje+sIvxBk/veOk7HsD/aCG4J8IVaQzuAcv1HlIjMGaTANShXY6sPiHBZEXzWqhLEQdyTxWm08qKzX/kD7Zh7E81P15I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748853005; c=relaxed/simple;
	bh=vSNbf9ljxTuCzpts+EJX1QJngo8tu23WQpMSY2jD4QI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QQB4eApJD9sG7aiMqDkBmiayhvXHION5WZTiAqlKJQiPdecHeyptFnsIjXhDIpFYlaRij38dr5idIEsKUAISJ1n976oQjz1ltE2D1Orl5NzPSFn3bJD3NbeJzlN+i4dpfqYjOZpsGRtq/UiDDVIeCnbgtfY9FEMcH0ETV/S57wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synopsys.com; spf=pass smtp.mailfrom=synopsys.com; dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=DbevI6YG; dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=h1QbJcFB; dkim=fail (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=RhRb4Q9i reason="signature verification failed"; arc=fail smtp.client-ip=148.163.158.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synopsys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="DbevI6YG";
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="h1QbJcFB";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="RhRb4Q9i"
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
	by mx0b-00230701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5526rcee008317;
	Mon, 2 Jun 2025 00:16:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfptdkimsnps;
	 bh=vSNbf9ljxTuCzpts+EJX1QJngo8tu23WQpMSY2jD4QI=; b=DbevI6YGPqfA
	+LAjIzzcqJX7fWFWQFeip5Y6PZ8y3bXZcAHExnX6lXYgoNxpTOd2nOjB2m2So9OX
	HXTFm+/qlI3dCPLz4XFP9w+XAlRYTGsn0Yes1gtskogZW2MF5mf3+waG8F8Uz6Pc
	H34bg52YUaCGCmVV3vzxf9rq+AKZ9sKrUGRRhba5y1nzfSCrLMWOmhtOmjw0QtMS
	CtUrG1oe8+imGNrEXhznXljEOV28TbpKhmdvLhB+cB6fcEwy89cgYDyLssfFUJ7i
	Pz+smYMxfiBi54URVdFt+ZQJIqoUjojII6ERCjU5huU+L7vKLUv2K2TYNODjCYNK
	1BCLGGIQCQ==
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
	by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 4700dempgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 00:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1748848582; bh=vSNbf9ljxTuCzpts+EJX1QJngo8tu23WQpMSY2jD4QI=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=h1QbJcFBgcBXyOjI7tUTjxrK+RlgJ9YnpCAAXXeDy5WQlVWVz/ORAAyAPo2kRK4Ob
	 vP7A0SXcLwlXfsYT/EA04/UL5uO6p4HKjn540LZjGs4AMq1SWr58+U+rspIcuTQGJP
	 ka+kJbuYjns9V+OeSwgZ2k1P9W68hIuofcXjgBIX7DAEkpuSo3nG0rXPqZUcTBNLDZ
	 bFsVmcnYmUPI/eC/dM4/VrUF2ad+N4ZoNUWRqmPeNtRmd3uU8K1hZ72IYPCVV8NWZs
	 wv4SZM0KS8gKS8uv4g7f2IUqmMkUCBPUtuJMABD0Yb2xEOFuBdxXB147A7btrhW7qK
	 XpVBNGF+noyag==
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1FE5140235;
	Mon,  2 Jun 2025 07:16:21 +0000 (UTC)
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (not verified))
	by mailhost.synopsys.com (Postfix) with ESMTPS id EE5ECA0071;
	Mon,  2 Jun 2025 07:16:20 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=RhRb4Q9i;
	dkim-atps=neutral
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id A31074035D;
	Mon,  2 Jun 2025 07:16:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IoVwULcSe4RThXaauG7MPWvzIL1UH6oaGr4DICd6TMNo6M4gxGiKFJdH8/gcWSd/tki7d9M1mVoN49wPvl8J6/oNm0smq0uetfIw/ruLFi3uSKq0rUu8tby8Ye9QyjQeqnqTUhzx/o5o9NS0f5Y1Iprya6Obr1gCwPB8vbohI8fJdsR4vcEvG8hC336k+u32mMDlXEJi+G2WfmSD1nlcw4wgJDq3AggHNh6BILhQhVzsy1xVPkKDqja4zEXFGRQkptN9vVLFWEV2NEASl2TwG11laoS82iFfsUtmU31zxcpOFBm/Pe6QwHKkz3Q7sddf1qu3zNoLXotUD3GqL4i6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSNbf9ljxTuCzpts+EJX1QJngo8tu23WQpMSY2jD4QI=;
 b=hHGnfbJHzqFcDMT7W70DEsyIUljLFtZd28cM0glb+RyGIwS0A/sPNo78MHUUh3+a3YI48B5//m0evBAA+pb8JNxjyZ6Ia/glywfjkUS8KTuebAVRmBYQmQAMCHmphJLG6Du+5PllkdYXYVd9Zs0GAm5cGIxubTVOD1WQWznG0WJWWEgVgsTOPL3umfy2phut7XSFVWkGgc9f2IpmXt3i6PTbIMWCuMU2PL6AvVryDzzXj/Tmkka9k80BZdk9fSnwNmv3VuWlDMmGHiOV6Wp6adQZoDPy+I8oFhVnR5hsFThToCH4MhH/L5OHM0WkIIN4xeqyyhdaOoWLQDLGNdN0YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSNbf9ljxTuCzpts+EJX1QJngo8tu23WQpMSY2jD4QI=;
 b=RhRb4Q9irS0siqxUu9Ch3rqr1JFpXb6LSli9o0+++808Egu4cLszPBdrOz/02H8E3v7Yavs2XHqV4rjthEsSJ3n6V5eKUtzQoNt760TJDJKRaKZNekcmFLBtYatrPd0JZB3U2UG3JqKMdEjHJB+Zxwd3ehM69oZ12+pboJlnYBA=
Received: from SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16)
 by SN7PR12MB7201.namprd12.prod.outlook.com (2603:10b6:806:2a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Mon, 2 Jun
 2025 07:16:16 +0000
Received: from SA3PR12MB7997.namprd12.prod.outlook.com
 ([fe80::7d78:fab:d772:ccf0]) by SA3PR12MB7997.namprd12.prod.outlook.com
 ([fe80::7d78:fab:d772:ccf0%5]) with mapi id 15.20.8722.027; Mon, 2 Jun 2025
 07:16:16 +0000
X-SNPS-Relay: synopsys.com
From: Ruud Derwig <Ruud.Derwig@synopsys.com>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Pavitrakumar Managutte
	<pavitrakumarm@vayavyalabs.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>,
        "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>,
        "robh@kernel.org" <robh@kernel.org>
CC: "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "conor+dt@kernel.org"
	<conor+dt@kernel.org>,
        "manjunath.hadli@vayavyalabs.com"
	<manjunath.hadli@vayavyalabs.com>,
        "adityak@vayavyalabs.com"
	<adityak@vayavyalabs.com>,
        Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: RE: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
Thread-Topic: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
Thread-Index: AQHb04AYluAC4sK/1UerNtxJU9QrS7PvZnCAgAANDBA=
Date: Mon, 2 Jun 2025 07:16:16 +0000
Message-ID:
 <SA3PR12MB799793B379EF78E1CEE9D405CF62A@SA3PR12MB7997.namprd12.prod.outlook.com>
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com>
 <ea54b6ec-41b9-4962-b22a-115ccf521076@kernel.org>
In-Reply-To: <ea54b6ec-41b9-4962-b22a-115ccf521076@kernel.org>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-dg-ref:
 PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccmRlcndpZ1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTc3OTA5ZWFiLTNmODEtMTFmMC04MTgxLTI4MmU4OTFhNTY3N1xhbWUtdGVzdFw3NzkwOWVhZC0zZjgxLTExZjAtODE4MS0yODJlODkxYTU2Nzdib2R5LnR4dCIgc3o9IjEyODQiIHQ9IjEzMzkzMzIyMTc0Nzk2NTk3NCIgaD0iRTJaVmtvQVdkZ3BVcVFlakhWRU01SnhraXI4PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR12MB7997:EE_|SN7PR12MB7201:EE_
x-ms-office365-filtering-correlation-id: aa703350-5546-40bf-fc1a-08dda1a55d6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RStWQzNXMGNES2dXOHBzMG03MkhRS0Y2ZWJ1a0J5VkI0VDY4eldKQ2oyVDdl?=
 =?utf-8?B?b2Z5N3pmdWp2cXhjRVFGaWNVUmpLT2VUdTZlWndUSGFiZ1lwV0x4bEtQa0R0?=
 =?utf-8?B?Q1ZrUXJoZjFVZXMrM2RCejBCdGREaVYwZXZ1UlZ4V1ViK3NqVXZLVmtNOE9R?=
 =?utf-8?B?Rzd3VmVxZE10V2RuYXA3R3greXkvdVJWTDJMUjczT3pMUTFwMDBnbmQ1Q2pR?=
 =?utf-8?B?NGREYVhKeHZuNWdleXVvUzQxRXQwQ2lyakEyUDVQY1kramVkZW9hc01kZlJ2?=
 =?utf-8?B?VVhMeGh2amRLT28xT2d6TmczWU1pdk1ScW5XdkJZTm0yRk54eUpSM242d3dM?=
 =?utf-8?B?S082SThmaEtPNU9NZ3d0NTFSVjRIN0dENWZSeDM3MUZOYkdzM0gyZEhlWDlv?=
 =?utf-8?B?R1hCVHV4SU1QeElKZ2pnNFFmK2dkbkNHVXplRDFHclNKVDl6RkVjLzNTZ0V5?=
 =?utf-8?B?ZmZVZTQ1Z3E1dElhcFA3SjlUaGgyRDVjcXBCL3ZjdGdpY0Q0TndBZVMwWGFm?=
 =?utf-8?B?cHJwUnc5ODk1Wi9iVWJQVnJndS90elA1ZGRRa29Bc25rcnoyUzJhTTdLQUlU?=
 =?utf-8?B?SlFzY25yeWpSZ250dHFrTjE0U2M5ajdyTlQwaHh6SHR1aUJDZHBBWHdXNmh4?=
 =?utf-8?B?NHFzaHpKZlNYZnREcWk1aWVZYk9tM1J3Zm5BQlp6NTEzVk5oaDZaSmZibXRR?=
 =?utf-8?B?N0NmeW1WM3ZsUzF1aVZXbWJtL01IbFNKL1ZvUS9ZRkR1WlJrUlhXNkNuejJZ?=
 =?utf-8?B?Y2E4dHhPVnZSOUJCTE9QRXBkajJyQnZWSnM0c1k5ZGY2QU1Tb05ub29pQytn?=
 =?utf-8?B?STBwL0EwVXZFeTlhWkxCbTBuc3NDNXpOUllWTXFId2RsR3JzODlKYVcrdVND?=
 =?utf-8?B?ZWZqRzg4citKSEVMQnhaM3JCWmtRY0x3bnI5MWErTHlWN1hSMlp1ZlJZZHA0?=
 =?utf-8?B?Unl5NksvNDNuUk41UG5LVnlkdldWSlUrTVArZE1tODcrRTV0eVhmdnZrV3Bv?=
 =?utf-8?B?aXNiNlhPNEYvUE50RU1UNEJFOXplZzIzZGFydjJOcjN0eGNoRktkNm9LR1Jr?=
 =?utf-8?B?RzlVemRianBORXhTeUkxUFZ6MGVjaHduY0NhclgydU9wbkU1dVo2eWgzMDRL?=
 =?utf-8?B?QTd2cmVjQ2NlOEc3RWkwOXdjd0lCdXdIQXFkaXRNbWJwdmFoWDdZYWtXUEQr?=
 =?utf-8?B?czF2SFdOYXNiUkdNUkdZNWZrOUJNUkZCMjZoSmQ3OE9tZURDZCt1TDBtaGVz?=
 =?utf-8?B?WldUUEdQMXZTUjBZWWxaSVZkY1U1bGU1S1hZRlRWTHU4WTZtSERUMEZpQmJr?=
 =?utf-8?B?ZEhJTkdBcHdmTEg4U2RsV1ovN2xoMi9lM2VlNmNBcnk3M1AvTW9uUTkxakhY?=
 =?utf-8?B?eEgvNDIrSzBkOE1SWlhtNlZISHNncU1UWmZxYlV4SmhCMVZZK05pWUp6bWtq?=
 =?utf-8?B?a09WWjFiaDhvVGxPWSszZFZIV2wrU0k3Q1V4aS85S0lRcnpFZGRWRkZBeFNP?=
 =?utf-8?B?dk1IYkt3OUZnUUdxN2xzZ1pXc2ZXYVpzYmRqMFVyRFJQNjhTQ3l4TUY0ODJU?=
 =?utf-8?B?V0svS3oyK3ZhbG9SQkoxcGFIblNMU1I4bEpVWkJPakozbUh0T3Q1bHhGNGJn?=
 =?utf-8?B?Z29mdVdVbHNwenBnTWhaeUcreUNSdzBveXhNZ1BqOXVWM0U2Q2tiUktUNDBG?=
 =?utf-8?B?bE1qNTVDQ1dBVUk2Q2ZnMVYveVlBVlFGSnNNS0VYOVYzNUJWTEtPTnRkYVY3?=
 =?utf-8?B?ZFh6SytTMUN4TldvSlFXdE43TXNXUGlNYTR0NGhDTm80MUhYc056WEJjYXNY?=
 =?utf-8?B?ODFNRHJkeEFPdzdlc3ZaM1gxN21jYmQ4V1dEVmMxdTZ5MGFEQmorcWZaVkhi?=
 =?utf-8?B?dVhGVU5aaUJBNUxSaUtFYlloa2xpN29NN1RSbVRTWFVTb0lmSVRRZ1FwQ2pP?=
 =?utf-8?B?NUdZK3g3NURCZzJVM29lV3BaZWRURzJxWk1UODNTODk4dnBvWEhvZEJscjhk?=
 =?utf-8?Q?GbXqhuiiEj3OGwgXnkavunF5L48TPY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7997.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UjVXaTIyeDVESGo1YjAxQzNTMXlrNEtNcmtFNktDUy8zKzBVSE5TcVlXOFJV?=
 =?utf-8?B?UEl6N2J5WGpMa0RhTkRvMVdCeWVjWVhXUkVMSGVSMm00ZEp5Zlh1OEVZRXdC?=
 =?utf-8?B?bnU3NEFVUWdXUlJkY294QmVIOTlpSmxXUGZuWmYrQUpqcUQ0aXQ2TWhNY0Nr?=
 =?utf-8?B?Vkd1NFJaUXNONktTQVFRbHFWR3pnYU1GWVhzbmxHOWFTbnl5bXBxU2szbWk1?=
 =?utf-8?B?VmtyRWcwYkNaTEVUU1l4U21WRE9MbHNCQWp2RC9TVXJzeU9JTkxQMGxRMVdC?=
 =?utf-8?B?ZFJnekdKald0clJ6ZW5wc1BZTXJ2ZUtIVXpqVExkc3VhamZJdVFnY05BVG4r?=
 =?utf-8?B?MmYzZ2dQUGRtYTl5MktIQ0ZvQm1MUm5TQTNBdllwYm9MQkdJR2lZMzZ2UzVa?=
 =?utf-8?B?dE5oUjFFTEw5OW80dTdyeXExMkdTYjFJZWxncUJzNWZCQVJLOFRGbFRCcFpa?=
 =?utf-8?B?MVJsQkFSZ29rMEtTb29jUittVXFGcGlCK1lMMURmQ2FZVCtjeVd3T05rOUJh?=
 =?utf-8?B?TTN2bkRGYit3OHUrV3NmbHo0V2FhTndqN3o0d1FkaGhFQjNWRlE5RlVtckNk?=
 =?utf-8?B?Zlp5UVJxVHhTeE1nQXEzeUNjbGlhRmJqWFdoaUlsMTNreE44ZFNZRlA0L3ds?=
 =?utf-8?B?SFdJN09qbEV4cUwvMjU0VmZNelU4TzR5b3VMSmZDMkN6ZkdGUE5lOU5pZ3pI?=
 =?utf-8?B?ZFAyTUwrYTVENDNqOVlkTElRaUk1a3F0b3oxSlBmRkU5MktDRWVuSVZyQ2Rr?=
 =?utf-8?B?QmNOSWdmcjdkRC84T0xEOWRybGZnazNOU3h2NFVzMXhvTGQ3eXUyRVlXWUpQ?=
 =?utf-8?B?YWVka2l5Qjg4QUhFMU9aRzNoQWZuTHdaYVJOUXY1RTRIVHQrb1V6RW9ITzlR?=
 =?utf-8?B?cElMM05BVDFQa1pQZGlHQU9CTlZsTzV1dmVmbHJMZGhYRDZaZnNRd2Q5K0Yr?=
 =?utf-8?B?MXJ2RVg0NHlOQXpXNDhERXJEQUk5SG5yT3J2b0R4NUF0YzFXa3ptZ0NTTEdo?=
 =?utf-8?B?Uno0Q1g3UUF4bUcrM1MyQVpaTVJVUHVUNndOM0VrRExyd3VIY2h6dnhNMTFE?=
 =?utf-8?B?SGRzeFZTaU9ZV1FWQ0puN2xzZVlHckVqMUpXM1NuMVk5ZmRuL3pxa0lYempJ?=
 =?utf-8?B?L295QkJ1ODF5M2FFU09wNGQ3T2tEOGdZenlLVXRzaWdETTU0QmZjKzNlZ3JM?=
 =?utf-8?B?UkdtelBXTnVWMEtxN0hqazlPUThPRDUxeElZdy9mbk10bXB0cUZreC8xOFVC?=
 =?utf-8?B?cmI5NVNnK2MvdzFZR2JmaTg2SUJ1QnN6M3FFalVKVDZ4MVg1Wk8xaUs5WFNV?=
 =?utf-8?B?ZkpqQTJ2STYremRpbVA1YytnU2t0bzZmRytxWEFLeEFld1ZrTjgxbTArUXAv?=
 =?utf-8?B?cVNVNmxZRmpaeGsrYnRWbTZuc0FXZVQ3ZnNCWUc4QmtjM1BiSXVqdjFKRWhB?=
 =?utf-8?B?clByMktsdFQ1aFpaMWZwT0U3YklyRkl6dC9KWFA2K21IYXJ4S3dyY1V0a0Fy?=
 =?utf-8?B?QVpnQXVhamh4dG9zSlNqY3dBeG41ekp6MWlwdFFxWjNXMm03WUJiYkJiTnNW?=
 =?utf-8?B?VCtQS3JlY1NNYVJoeWdQZVM2aXBNYTRwSEZtR284TVZWalRYeVlyYXY0YjJr?=
 =?utf-8?B?SWVwNDhJMW11SXVNS1lVYkZ6bWdndWx0eWFmZGZzdFpEdmQybkx2b1VtbHhM?=
 =?utf-8?B?TXhVaDkrdDkwOFI5aDZjM3lSalNhNG4wVmthbW9rcXNGTnZ2S1NNa05HSXpV?=
 =?utf-8?B?YXdTakI5MnBNV0tYN1BOSC9BMEl0S0NQWThhSE1Ea0JqNzB4MXR2UGJUckpn?=
 =?utf-8?B?bTVSamlYT1BpOFp2d3gwMGZYcnF6ZmQ4ZGFHNi9EUFpoclAwQTdLMVc3REg0?=
 =?utf-8?B?YXlmU29QenE0eVRaYnlUK1lSeVhiNU1tNnlZcC9PendEaTEvcDFZMEUwWnR0?=
 =?utf-8?B?SHdMWUx5S1B2MFNBUC9hWGsxV1lNY2tEMjc2WXVnYnFsekQvcVhjWDZBYWlm?=
 =?utf-8?B?Z2tEY3VCb1lGdjNBbDNzaVJrR20yTStOSW9sWTJkb2VhWHNYR2VaT3VZMHJZ?=
 =?utf-8?B?UzNaWjR5cG1HUU1lcm5zSTUwdUFUeFZTZ29hM29rWFpXejZYOHRqQ1NkU3Iw?=
 =?utf-8?Q?RZGVsA10+6RbDxeHOK1HRXI5M?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s5H/TuJjnvd2KfnhjRNwTsaq5UbsWg+i7YZh8CEGONhagzJXD1pGY3Qv3zbWvjn7s8yhOJaqHDNhJKMOsOurEAb+4UFHc+zgw3tZWiLbEOqpJ8988XD3F4Y9KI4GVrN3m8vaKdPRfYNq9TT4qQjFVPv6cS7qmDo7MLTqjnkfD+qfX4EfP1IyKRXMHjxZlwyjF2juMcRehBXSFnyL5lkY5l5QUCFT6HfGR/QtcO7p8qziJexjUArhDUGcns9aiZJjdV6DR4KUPekAmz3gZWWbwzru0dumbBzBYvslDbav80Km2lhC2rAL5clcxyJDKpU5asZ1QtZc9CPuWF9EkcePhYaccbmF4hrmpZORu20Ax3/HHJMNNy480PXbtezS5rCvDXilgv/0ikTnVVx9PBY/p7VsXWS4+K5t3Vwf4FwWjMSD02mrQCo+lGQaMCwTVlK8sEFrckEh/IL0vVMvfyCr3CItl6EE/mm0OcFjVUdRc9aqMR+WOjFezSi38H2BFULIDjjTPoqIwtrkwyBfc/mcpeEvLE5ZULiR1C5+AStNMxPXOWOQFkTxFzQaAa5vYewKBRygtX063FPrR9efZqVve60PAdG/97mpdDuaPHkEtyeq4c+ieo1B+dDtpOSZon1NenOwOUAuc2iTBCm4gbIvHw==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7997.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa703350-5546-40bf-fc1a-08dda1a55d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2025 07:16:16.5596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MLkYUsX9YQRruYbnmICFtM6CLMUXzKV1kdazvnDA0StrDf0uylxP6t4MarrkhctPfxCUM9k43nybmt32gfwpGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7201
X-Proofpoint-ORIG-GUID: jMifqFLllMaR_HXD8uvcmruy45maBPQG
X-Authority-Analysis: v=2.4 cv=GohC+l1C c=1 sm=1 tr=0 ts=683d4fc7 cx=c_pps
 a=t4gDRyhI9k+KZ5gXRQysFQ==:117 a=t4gDRyhI9k+KZ5gXRQysFQ==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6IFa9wvqVegA:10 a=qPHU084jO2kA:10 a=jIQo8A4GAAAA:8 a=PRd05r9ESfJoCWNB0EUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: jMifqFLllMaR_HXD8uvcmruy45maBPQG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDA2MSBTYWx0ZWRfX4r9UhGwg2uH3
 zrHLoMjpgV6XR08gaiG23Uivrb0siqqY3FxL5O1+SJ8qKeCGWSSQqal45YKJFLzgIFNq+MZuEHU
 IQWAX+l+nUcrnKvDud9cpl+vhtxRQzUZJ9XZwDxZq4jrLlt8wZSWBnaAcC0hUEG/k1wd5Sk4Gb1
 0kMdYJ/RT+iboKZcNdMVuKYE+ewgvINdOFNoKpv1RSt6b8GxPl+5TmAnV6vsUcgndym7prCwtIH
 hYoJERUqjkE4NPJ+dj/ctGAHDw6Bl3vNWdcvVYPZr0Q3eV6u5ti3aQw7Z2Nxh13JC5Vvg4Hgt+1
 h+lGw/gZEQ7R/r23IEAW+1Sz06wh1mYoNwspjGbsipPKaFafZ2xAMy8uEeXOw79KlbKN4LUKegJ
 z5BmgVSsT0nnP1lyG6Z/bptbSyLA53CH4JJ0BqCuyrj4+s9rr8si1v39+29BILAO67WK8JQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_02,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam
 policy=outbound_active_cloned score=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 mlxlogscore=942 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000 definitions=main-2506020061

SGVsbG8gS3J6eXN6dG9mLA0KDQo+ID4gK21haW50YWluZXJzOg0KPiA+ICsgIC0gUnV1ZCBEZXJ3
aWcgPFJ1dWQuRGVyd2lnQHN5bm9wc3lzLmNvbT4NCj4NCj4gT25lIG1vcmUgdGhpbmcsIHRoZXJl
IHdhcyBubyBwdWJsaWMgQWNrIGZvciB0aGlzLiBXaGF0J3MgbW9yZSwgdGhlcmUgd2VyZSBubyBl
bWFpbHMgRVZFUiBmcm9tIFJ1dWQuIFRoaXMgaGFzIHRvIGJlIHB1YmxpY2x5IEFja2VkDQo+IGFu
ZCBSdXVkIG5lZWRzIHRvIHVuZGVyc3RhbmQgdGhlIG9ibGlnYXRpb25zIGNvbWluZyBmcm9tIGJl
aW5nIHRoZSBtYWludGFpbmVyIGhlcmUuDQoNClllcywgYWNrbm93bGVkZ2VkLiBJJ20gYXdhcmUg
b2YgdGhlIG9ibGlnYXRpb25zIGFuZCBoYXZlIGJlZW4gd29ya2luZyB3aXRoIHRoZSBWYXlhdnlh
IHRlYW0gb24gdGhpcy4gU3lub3BzeXMgYW5kIEkgYXJlIGNvbW1pdHRlZCB0byBtYWludGFpbiB0
aGlzIGRyaXZlci4NClRoYW5rcyBmb3IgeW91ciBoZWxwIGluIGdldHRpbmcgdGhpcyB3b3JrIGlu
IHNoYXBlLg0KDQpSZWdhcmRzLA0KDQpSdXVkLg0K
