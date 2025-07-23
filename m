Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637B2236F7;
	Wed, 23 Jul 2025 18:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294992; cv=fail; b=YloEa1oqswPig2pszwqkWsDpQGD/j6NgPhbyJuaMmpjCBnWHbQMFgZolFZJKA8VrwmMy3q+yWqf78g96sTV8RaSbgvdJM2g1rRbUAD/tttPIV0ikx1puoo/vBDnXXcXm86mzT90qG0Qg4XRHhFTRzTMmuPbxr+uDyC30F416vR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294992; c=relaxed/simple;
	bh=wa/VWqXAUeH6CLyyOMpPV1kHM/39MXHxFoklA/4H3HU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z3M5bMo2UmVxLyNyQrHDKV/MCBMmr8ShI1suaxMlyiz2b7b2k+ZMPtiAYCyk1i1E+xpiu5QpZ2GIPfY8PrcZDcge4bWR+l2J3qz4nLISSfVS2gM3SXvtMhmOUQpEW5luwST0ZS5qhSBnwzE/LYZWyIzFhP4qL5eUZFO13BfGBtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PLoxaGF2; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PLoxaGF2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rSQsKuiPWXXMkTEHSrswEZLHXe8t90d7Nbk15p9o2Qi+5ggIi5yIaYXue7IfarWt03F7p3/QDlNOKXKMXAgalmg4bioMdnYKYaWlwhwt6JWgI1/pbIN8TtHB3H2PyDnyDgOPoG9pgzwdKeTuAwCqfgVEFFYybHenqqhpjbrMwOlMCHkFIxDadXTfX1zLeN9mFbW0kEG6nZUk6eZNBck3fPh6fksZidNmkOUxgcz9g2WoFsapPCZ0uN0dsSpGm//db7IWJTL3jpmJsBlguK1TPx/Z+eiVrh6qzxkfocCctqoMNYjlGpSzTqQP+APGFjGH/kvWh81NCghK0wPK7YCczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=011k+Gf10p2iRfVZET7OkhQz4iuCx9gc7wfI3Hm7OEY=;
 b=nk+9ZUz5U83zGlx+3CqjMun9O0oPtdXA9l3+RXcBJcxQDHQ87aIbGmto0+21VVhxGvfQnEo00i1ZlJeGxp07gLuLseHEsJ3geKE0KIPfFTilsgcRx1P1Qfe/qpM7FAZ/LMZjvfsrFIs8v5aKD/riJc3xnvkfr0HRlj47ZcvSQZUuXC/1tv0HOu0jUYuZbLq+y/5y0tYYRGqqlUChIuBiLyFg31CCouL+LYppTbhUqOp9vzaYOnjRzVeBEHjVWeQoVJHQw/vZvWvyaIl0MFQMXxws22ENzuJVzN23m80Gp//az+KpBF1mttodHxL7nuNl6UBefRt9WqOpmR1IH3qAcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=011k+Gf10p2iRfVZET7OkhQz4iuCx9gc7wfI3Hm7OEY=;
 b=PLoxaGF2jgapm4hPz2lcjxmVipUXsG/eKxGGech1cyAIcKcsNorrjKXCp4yIT9x9t2xGaDk/N6S9EXohydT6Svmn+D8S5Qx1F47q72vh9+yPaMf/osHE3fGtROOtuXydpgFiXQEQaoz2MQjo3K5+CzM3xV+rp7GFK5xW4h6Cpxo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8725.namprd12.prod.outlook.com (2603:10b6:610:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 18:23:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 18:23:07 +0000
Message-ID: <de7c13f7-42a7-947d-0973-80ecd814aa42@amd.com>
Date: Wed, 23 Jul 2025 13:23:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: reduce stack usage in ccp_run_aes_gcm_cmd
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250714145921.699060-1-arnd@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250714145921.699060-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:806:a7::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: e3bd56fb-d636-4926-e38d-08ddca15f8f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3FCUG82Y1dwWFJSdHMrRjUzSHMySjRnTWdoRytxcitYZWJ0cWlpa2Y5ZnpH?=
 =?utf-8?B?Z0I5V2dGQ3Vmd1VKT0U1eXhkREhNVTJ3Rk1pc2NKcTBPNVJGczkxL2F5UHJO?=
 =?utf-8?B?SVB5dGdCcW5sOXdWWFdub3pVVXZQQUdUN2tGTFByMFpVVCs0bmRINWlCUXlO?=
 =?utf-8?B?eU44L0FKQ1UzbjQ5MkI3RkkrUWhaa0lBVFE0dnFQaTZpUU16QWZYQ1pJM3Bz?=
 =?utf-8?B?QjhXWnU1dkswckJ1aWdHVjJWdGpXTnNvdnRCQ0s4QTVqdmc1aERKaWhyeXBN?=
 =?utf-8?B?UHk4NzQ5aUlaM09aZDB3eFZQbyt0Y0h6QjBuS0dJeGtydEFpWWZaUDZhZmZT?=
 =?utf-8?B?THlLVEhPalhtdHBqVFd3SzRVaUE1eVp1SGt2QXRRUk43UlpGSGdHMXpHV1Vx?=
 =?utf-8?B?alNMSCtzR1FQVE5ZTWxqU1BYTVBTSysxUHBhUG82S2JZZG0zZW5maVlxZ1J2?=
 =?utf-8?B?dDlVSEZzNWZUa2ZBSThmZnNuOXNySmxjeU9oTUwycjFyNjgyY0pHVzNpaTNl?=
 =?utf-8?B?QWh4ckhlOFJsZSs4ZitiUVFDWkZvMUNaU2ZpSHA3a1ZxcEZYUDZXbURhVjR0?=
 =?utf-8?B?c2Rub3lMN1g4T2RjYWdwRjNsRDFKSXZpZXE5WGVaWlhMc3AzWU5HWlprMWZX?=
 =?utf-8?B?UXp1c2lwTTc4N3gyVzZ6UTFCT2h0R2JwZjM2SWJ3ZE0wSTRGSVlPVTdBMmZn?=
 =?utf-8?B?cVh5bExRR0p2Ykx3a204ejNpZnBNTWVuOG5ORG1CbVlHbWN4dDJqZkVFbks5?=
 =?utf-8?B?Qms0NW42VElnOVBMUTJKYXZ2Z0FIWUtqc1Q4eHV6clZMY1hmR2dBOVVoREpD?=
 =?utf-8?B?YVpWTDB1MVNLRFRraUUvRzVYb3U0eGdvM2RLUDlOUXQwME1BWUlTRFFzOEN5?=
 =?utf-8?B?L2dDVEtKYW80RDVUeEo1Q3dZZXRHaGkzNU9sSFI0REJwdjY0NUVzeEhqTE95?=
 =?utf-8?B?bGF2eUc0aVg4bExScmpMOExlNm16R3RPUmloNzBUWUlxbzMwNS9CZ29ibFNy?=
 =?utf-8?B?eE4zNlR2R2dlb2xtN3BIRnRjeDZKQTlCU0FOTXNvZXlCYUlML2ovRVN1SGxq?=
 =?utf-8?B?b2g4NUt6WEFJdnFCa2ZqU2lLTnBBZW5Jd2l5RFRESEdYWE1pRGdsMmhZbWR0?=
 =?utf-8?B?bEdmbDR4TEtHM3MvOE1adlVoWkdIbGg5ZHlDb2I5MGNvalMwR3hQM0RSckVG?=
 =?utf-8?B?c1M5VTQyT2dnMkt3Z0pEQytzK21iQzZpb0NVSDhpWFR1UFFwYnlieDBSNWww?=
 =?utf-8?B?OVdXSElTckd1OFF3b0htMnRZQkFpdUJmSFlWb2RMSC9acWw3eXlXcTcyRzFS?=
 =?utf-8?B?cHh1c2pNeENQem9KRWI2Uml2bHpUYVJSRStuUTJqMy9xb1hTN3JFNFZsQXFt?=
 =?utf-8?B?VWZqQU1TNnJibWNKNm5BdEk0M0JCVWI5c21oRHpvTGgvTXlIMmV6aWZsbHlI?=
 =?utf-8?B?clNteHlOcmxOTmNDRG9CWENBSE05bEtQNVlHV3lYTkl0MnJVUnNPZWI2Z092?=
 =?utf-8?B?QWlLdnRBYVQrdm5ZZ0hwWFUwWEh2US9NbGtPUjZ4VW9OM1N2RGdYVERJd016?=
 =?utf-8?B?em9qeFgxVUFoNUFxeXlsNndObVdFZk1PZVVTWDVGRDhVRnBxc1A1VmdDRC9u?=
 =?utf-8?B?cWFLRVJEY1pPRWdMMEptYStmNW5IWnRURG45QXR2UUo0TGZVQ2JRb29iTDZF?=
 =?utf-8?B?MktWMXdtODJ3a2VnSjlodWh3Vm9VTXlCNDIzcVJuZWFtOUt3N3dwUDh2QTVV?=
 =?utf-8?B?RGJPbWovZXBCek91R1lGd1BuZ3VBM1A1MjZsZ2Y2c0VXNE41K0F2cjQ2L1hG?=
 =?utf-8?B?NnY2MnMwUFFpQU9VSjVsRlVQUFJDcFJoNlRsTGY0V2N3NGMwdUZ0Q3ludHRi?=
 =?utf-8?B?ekMxOERZUkczTjAxZzJhQ2JSUHQ1bmNUbUptMWdEaGVtZU9qcnB0UTgvZTlS?=
 =?utf-8?Q?CCUgpbGciP8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3dpT3ZtVVhyOWpTdGQzMXFqamE2eUVMVUpmeWRqcko0M1lNUVlHck1sNFpv?=
 =?utf-8?B?bEdXMHltNjlQTHRoRFAzUXNDdXFTbTg3SERmcXlzd3NGdkpsN1VVb2tQamNJ?=
 =?utf-8?B?a0FrKzdNVTJUbjR1YzRLS081WXUzK01yTUYzaDJSb1hwWnh1KzlocTd1ckxQ?=
 =?utf-8?B?YzNVajdQUS9FWVNiNncrZHYwR3NBV0xxZEdKdkhTK1NjK24zU2g2ZDBDSjRL?=
 =?utf-8?B?OU0xV0J2WjVENUVhenpkWUY3Tk9jOE5LZzQ5ZGtGLzlkL2hLWDFPcnRLY1RZ?=
 =?utf-8?B?YW5YbmMwNTh5NXl4YytOL0xmcEdOUFlRQzAwdWprTFpBUnk5Q3AvU2g5WTNR?=
 =?utf-8?B?SWl0cTRKSktaVXlQUUpBRENRQVRVRHNuWVgzUEwrTFRUT3ZwcnNWZU5IRG1W?=
 =?utf-8?B?WDlYZU1ubklyZlg1RSs4cTJLRU85UExhcVVoMGp3VEJqZHVTbU4rYjRHbFN2?=
 =?utf-8?B?bUoraFZyVGpZUkVrL1ZaVTNpNzRUWWRqb2JuRktaWEZjUlVzMHZUdkI4NWtD?=
 =?utf-8?B?V2ttc2JhQ0s2T3JzRnE1M3IyeW5wdSttVElLaTA4dFh1ekM2QXMyM1VjOGdv?=
 =?utf-8?B?bXdGV09pQ283NFk4TzM1a3V3eHM3TWRUMThEL3Z2WnBXdnRWbFgxWG1IV1BU?=
 =?utf-8?B?dnpWN1lJMDd6citKcXp5WkNSbXNoLyswWHBobjg2b3kwMjZ4L3V1SVlLUDRh?=
 =?utf-8?B?OW9VdnRtUFBnMStGSkI5M3FZL3Z1QjlvQ255Y3ZER0V5Q3E5NU8zd2FiNE5u?=
 =?utf-8?B?QnZpc2JDcTRJVnlVZjU3QUV4eVFEUEs4b2RLMXZGU0hHakZNbVdrZUZFam45?=
 =?utf-8?B?TnFrK1BJTkhCRlZVNTNZS2VYOE9xN3d4N2U5Zk9UcWlJbThBbjEycElJRXp2?=
 =?utf-8?B?MFlzYnR0ZUxrclJidSswV0FjZk1xamZzWk5aMXVPdURLVStMa3JEb2s0U1NQ?=
 =?utf-8?B?a2Z4SGV6R3piU0pCMzhQNUVudlJZUlBaajFncXd1T3l1SW1sZ0NlWXo4TThs?=
 =?utf-8?B?WUl2RzVrcytUeVR3YmEzbmhkTGd5dy9zWjZDREorWmZleTR1REJ6V1VyRjM5?=
 =?utf-8?B?Zy8rMGxFVys3UnRxN3laakc4aXBJQktKR1hrbStxUTUxZld0VlFHMzVBcEdC?=
 =?utf-8?B?OFRZVjFNVFdwRjltOG5JOFNpZGtjSmhHRkFNVGhPMDdXNnhlSEtzNzNGcFc3?=
 =?utf-8?B?RkVzdFMyT240cG9MVkJhRUxZL2ZRbnpaekZab0ljeUdkU3d5Y2twYnAxYXVZ?=
 =?utf-8?B?QWRZYzF1T2F6U2F1eCs5MlRxSmsrbVNkNXp1UE1KL1dyZEs1Z282SnpiMVpQ?=
 =?utf-8?B?RlUwcDZzQzJZSVl4UjBQbFBEdkNtbm1pdEhzb2IzZWZkTi9kMTN4MkF6NHYr?=
 =?utf-8?B?OVFuUDVMb0ZxN01KeUtId0dPTGJuRjF1dk1QWG02bTJmbE9TMytEV24wRUhn?=
 =?utf-8?B?R3ozVVRqRUx6bzhZOHE2eHVZQnNNV0g3QkV1RUFxWEl1dHhLUG13dEpMdFpm?=
 =?utf-8?B?T0s1RnNpaitQMFBRYWxqZnRWVUZ5dEVuQ3c0OG1oTThFcWdJeWtnemp4YjQ4?=
 =?utf-8?B?L1ltUHAxUFZkZmVMU0VyM1pML25OTWNCVEh6OHJQTDdRS2tyN1VseEZyS2xI?=
 =?utf-8?B?RGNiT25rZFNKd1loakV1TFc3UFVHb25aRlJNM1VGT01YWUVuL2tkb3JJQkdl?=
 =?utf-8?B?c3RQRGdrc1JzdG1XRFJaYWhrVFdLTHBPQzdaUDZPYUx4QWJvUWREL0c3eUt1?=
 =?utf-8?B?Z2t1TFc1M0lCL1hWM202aTdST093QkFoTTFXV1FTdHdLaFh2ZWZ1Z2VEUm90?=
 =?utf-8?B?Vm5FU2duTXRtcWx3aTBZNTdWSFlibURTTDZmNFlRTHBVTGk2RWxHa2liWm8x?=
 =?utf-8?B?KzZQelhFTGdVR1ZXaFpkYktTajdJQjdJV2oxNCtFOFBkYzREd1QvSzhoS0ta?=
 =?utf-8?B?d01Kc0pMUmVZc1Z2UUlzQW5OUC9odFFwckN6OGlMMzBxMWJEYnR5UFZvUXB0?=
 =?utf-8?B?bmpCSGh4bUZBbkU3YlFMU0hjbm9oVndiSmNmbHVmZk9LTDNJd3crcWNhQ3hN?=
 =?utf-8?B?U01zT0F5ZzhQVmdpb3NncU5NWkpTbk9PRUVlQ1BJdXQ0aStPZ2ZuUmNVR0Fz?=
 =?utf-8?Q?9QxGO2W2OedNIDntSmvssas5O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3bd56fb-d636-4926-e38d-08ddca15f8f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:23:07.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: av7B/z5kFueMdAcWbxIAXETnJsr/29/ZkVqZchvfqEy4qyBFlXyyUe2jlP0YGikoLYfz4q0f4bLF46C6SZ3nbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8725

On 7/14/25 09:59, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A number of functions in this file have large structures on the stack,
> ccp_run_aes_gcm_cmd() being the worst, in particular when KASAN
> is enabled on gcc:
> 
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_sha_cmd':
> drivers/crypto/ccp/ccp-ops.c:1833:1: error: the frame size of 1136 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
> drivers/crypto/ccp/ccp-ops.c:914:1: error: the frame size of 1632 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> Avoid the issue by using dynamic memory allocation in the worst one
> of these.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> I'm not overly happy with this patch myself but couldn't come up
> with anything better either.
> 
> One alternative would be to turn off sanitizers here, but even without
> those, the stack usage is fairly high, so that still feels like
> papering over the problem.
> ---
