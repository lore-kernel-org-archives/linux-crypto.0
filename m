Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6434C3C4554;
	Tue, 23 Jun 2026 07:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201541; cv=fail; b=NiDclqvxlUY3rGzLN4V51GuRNmiGOQQrFLUQCG1R+qBNaBX9KM7A8OvXqjT/NPkL/EiifQSDVg14EghhOw6GU+jDe7GVpTvZTrbrae1KFWmSRJwCmDSbLYIvpTbCkj2OQxtcUxXiTB0igr6s9fXKY0L85Scb5ewHNpfWnXEjS0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201541; c=relaxed/simple;
	bh=69KNWj9NCGrRI1v4ns2ENrEk3L//PhgLVP9WNTkb8kk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IAfSlzXzJamTbPmf+qDF5kmEKW2+or3v8s+YmH8NczdqFqyKRIBRl3mUROaU93k16Xle7mbtMPbtn+2S2eRMzH0WU4Bisr/2rfGHTzWt33ncQD3lFHdGODStdnNuUyej09ikoOKEAuCEAF3FdtujEz+ZHj748S9vw26UbMUROSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=xvT8RpRI; arc=fail smtp.client-ip=52.101.201.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="xvT8RpRI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TzWrzEpBWzkrZMz3gf0I/EIrUgzblFo9uEM12BrgnoDmdkbFFAAanvwmmFNO551Z9RAXN3ACNGb15/fii1OBKw9Pss6MeyfrSJCwuxdcdJFBNbugXYkU4N8yBvNblixlz/KHy6lQ8HxChC4VfLSRmLqEmC8f2PkmIEZNrBi9DUPvWgk6NvOVzHA01gGZmk4VGeInTJ4WQwWeDMu9n47jboRVoUQNipX0Knfx0KmVtAGhITrUzgYX0a1zjUc1iN+PQ3jqXJrSg9EglXbb89jTbsuZZd1GPbLNfuFG2kcu5unJ2vv+Jq4L7k033G1TjvRP1SLxXSHBp9sWOA1IfradOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GA8yAzJhuYUBIFFGV8kK771KTnZh81DBAaj5JXtxrPw=;
 b=u/HJho6QgcUDy4/8o8ZwJqESY30+WU24eoegPP7F5S3Xlf1tOSylvp+k58U724crVmfTzXs9GWTks4TXZvN+jISkA3P4mQjbC9Edhm7ovJv4GdbKOA1rhhotf6UxmfuejWF/PznsSeLxk11+rrrdWD9u1hWcFrmATEQmpVH6OPn425HwAr9FTw2PvK4Qpja89tw5tqIb/MCEmr7YbWEn4QLgataHrxpHDvDTO8iaiL0IUNY2akGOq8YXCQcCRCHA0bMRyPmOPUR+lGno6EILjSJ2Hy1aDsdDkOkoLJDSsAjgQzD+cqy1pSNjksy6kP/h0Wnl3QSVyCoW4UG/e3iZEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA8yAzJhuYUBIFFGV8kK771KTnZh81DBAaj5JXtxrPw=;
 b=xvT8RpRIXMszaeKTZVywXkH4eD8XhleannryqkhSTJyf3uWhPNzZg+HTlqJccNHZ8CjfA2EnBzVUmVsrzuq/NW/6frFztnCBDG7In8jEISevALwxqQSvpcMG4jVKRsJ3Uu0NmsSVDwb9icqPUqz99aplFidF9mWSuus4TM8+eUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by MW4PR11MB5869.namprd11.prod.outlook.com (2603:10b6:303:168::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 07:58:55 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%5]) with mapi id 15.21.0139.009; Tue, 23 Jun 2026
 07:58:55 +0000
Message-ID: <0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com>
Date: Tue, 23 Jun 2026 09:58:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Jethro Beekman <jethro@fortanix.com>
In-Reply-To: <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070400070903050103030703"
X-ClientProxiedBy: AS4P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::15) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|MW4PR11MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 324ba153-b964-4e05-37dd-08ded0fd45fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|921020|6133799003|22082099003|18002099003|3023799007|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	SGRLCPI2aeI1uj01iGyfgx+2XSW8/ty++HMbRjHYEuV19hxz57UY0kb6oSD/rVQ0wWolMsTAhIcOHcAZNhV8dgs745BYAqI31LDOtA5f/YJlM/iRunNZ5Wsk3keGnsnG1izTj7m928t3sPuyyZafL9CSY6kBvzKcnL8wjapVdZ35XOnylnqeGHKjRv0udxq+pBUFNiQ2tQQndA+7vsfg2qbqh4ZeKdtLtuLtGkLqu1hRrLngNUXp2YZ/+GAM+NDVzviOEeHhVoM7EKCVPSQiKF3ro/swavcno5GktR+xvOT/fkrlGbstErFc/NOkQJ+RFoqeyn67heTicY/e0Hx9G1o9HUTOA7uKMEWrM8/ja8jWqzoZN6SN/3Jt7HSe4T31xVW2ZcNpcrnelhDhtkkt0NusluFfSclcuZiUloytXOa1OoeP6blOvtgzx13l+z9DiHwb3uAEJwFU5RMOWcREtFyBtmP9ILvHKK0LMUnOAFlObDcGk5pbaJhvmKWy8zU4FvM/bSV7If/uM6D/RLgftkahKDWn+WU3Xz98wL05ljKJeT3bkO3K9TzhVLNUQ9I+8xWpVCODzW0qTaj0lYLU3PhFM3qVm0YgAJPihEYHriF8gWbq5c046bk2BhlIZaPF3YfLFlUDVLSDuLz9GZ6C/LmZmv3hm0HVZhZ+g3ZPhHg99HOjNLVRlWzGHlWQNNVEodfw/yIcPNFqiLBmp5P+uQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(921020)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWRtQ3R0cTdzVmRwN1ZBYjVpdDVEY3BMaG5lU25kZDVCdkRJUWtvYi9KWktW?=
 =?utf-8?B?eXk0ZXN5UHRLdjRPdTd2eVFTOWR0NnBWT1lOT3hMR0RnNHN2Q3FQdXFzVjZW?=
 =?utf-8?B?RFBBdGw4UTdNTXJHcVEveXRoTG95UE5IaEFoUnl6anVNd29PTmV5THZUMXRG?=
 =?utf-8?B?YUgxbHJ1ZFp4SE5iaWd1UXgyVDhUbDZIMXlGeTJ5V2UzdzRGU2h3ekVuNTJC?=
 =?utf-8?B?VG5YcG4wZUpmUkREdmVjYWczem85Snk5dk9yeE5Db3o3bG0wMEZYZjZ2dnRD?=
 =?utf-8?B?bXZ3RVdnWVVsZEhQN0ZiUytXTENwa3V6c3NseU9SR1E2TU5WbzBLSTRrZ2FW?=
 =?utf-8?B?VmxmeE82QnRycmdGVGdOd1dQMXNmUmJOVFNjRTdRWjlYenJmejgvRDgrK1hj?=
 =?utf-8?B?d2w2YUw2Z1pOYi9YdUtVYmxjU0pkZit3ZTVadUJ0ME5WTXlqSHNNcFNwWCtt?=
 =?utf-8?B?UHVlaGNJQjJNSHVhdWZ0V01XRThOZVB2L3AreXRBY29qKzBUbzJQRXQ3UEhJ?=
 =?utf-8?B?NG85NkhZUnMxVFFXNUpNam5uZkFLLzlDeGZJYzRwS1FOTDZCNjdvT3FtMWQz?=
 =?utf-8?B?V0RmTG9Zd3FmWEpsRVhrR1NMUVg3QVBIdy9mNC9SQW9nRmlOY2RvSTFIQTBL?=
 =?utf-8?B?cjFQTHRjcUd4SUlCSEtJU0d2Y01MVklxUmV4MzlHcjloK1BjVHFrOU5aRkZG?=
 =?utf-8?B?dGRJaWtsU2pScHZPcHdRUGdWc1BRUzRqYWtkTzJhWUNJb2ZERVUrb1NxcTBG?=
 =?utf-8?B?N29JZVpsYlJpWlRhNWFqQU9lT1hHTUQ5Ri9aaEJRV2s2L0ZVL1pOZTBKS3BU?=
 =?utf-8?B?UUJlR3NYOWsrVDhsVXBZdHl5S0QzL2ZVQ3NVMlppU1NkN1E2RFlMdDFXeG9k?=
 =?utf-8?B?TGc5TWMwL2ZxZmhGV3B5UFpFQmh5ZTA1TW1QYjZ3Q1dYc0FhdUc5YTVjWEE1?=
 =?utf-8?B?eTdkZG52RFk4cklZdmRJZS9TdHZKZm9BRXI2WjNZRHhGaVFkdHF6c0kwejRW?=
 =?utf-8?B?MzhkSkNqcWdTelViWjMwZUNJdkJsS0hxckxoRWF1aUtKT2UzMHRpNzJONG9p?=
 =?utf-8?B?UXpQS3FuNVd2UWE0TWd1ZWVCWXhIdjlZbkFmRkliN2lWMUxtNENXZVo4U1dL?=
 =?utf-8?B?OTc2eWJ4d1NpYm9sRmR3R0psK2ROZktIU3QzYU1GRE5yUitUQzNtWldOaTQ2?=
 =?utf-8?B?aGRtT2xzKzJOcDNzQkVuNCsyUC9hS2tFSXptRi9yTlAzWkhCN2ZJalFwSERm?=
 =?utf-8?B?S2JyeHJadmxBSU51SHlGc2MyYW9CUEEyWHc5WlYyczZId0dZdVVjTEFheDdJ?=
 =?utf-8?B?T2RwbDAvc2txZ0xTT24ybzFiSHlVZkhzRFRhWkdBV2xmUDY1bmtGNWJsd2JK?=
 =?utf-8?B?ZUZiQkpsczFNMUJYb2NWM3BJT1dsL2JpQXIwRitpT2ZxZUxlejNrQU8rdlB6?=
 =?utf-8?B?TW1SSllXZFBEN2tmTDVGcWxzQVhWcTZtMCtIdUI3ZVJZU0RiQ2pxaldyMXM0?=
 =?utf-8?B?TExWeFcrQWdjbWNOZ3VITnZMczdydTJvTmpNR0tKQ01RUmltQ3huRnhjd1d5?=
 =?utf-8?B?cm9mTkR3OUJyc3ZZQ3AzVnNzSWlzU0dzekkyZU4yYkU0L3ZrNUxSejVMSkxT?=
 =?utf-8?B?SzYzbk9UVkkwdHBKY2xickJweHZ6VndQb3BkN29kWnBPektHdVYweE1XUFBH?=
 =?utf-8?B?SmJ3dU9JS1A2b25aU1BxNDVyeEhxZkordEJ5RGc5R3lMYkFhSkpZMUJTSFBo?=
 =?utf-8?B?VWZUazJhZDliUFBNay9kYnJJdXBMUm56cEVFRm1IczRyRENobDE3UGZJeDZI?=
 =?utf-8?B?cmlXZk1wU25SMVhCYXNXVVdEMm5UZ25iSVhlWXQwWE1mZnhWdmpob25mZmww?=
 =?utf-8?B?eGhXNTJXV1VCYTczd2VPZW1LbGZWdWlpaWNvejVxWXM1UTh1UHZHdmpPeXVp?=
 =?utf-8?B?MTlUbTkvanU1bjlReWJIVCt2ZEZVdFMzZXRJSldnS3poRkRISXBwL3V4d0hH?=
 =?utf-8?B?WHQvTHpuMGJ5M1JaallQallWYlkrczZFWDRiMkI0NkxjV0VQQU9Remx2QVZB?=
 =?utf-8?B?YTRxSnREMFdrZE9sdGppdXJmNlJQbkRvMEhUWHZibWFzdWVNK25XZFQ1MjRH?=
 =?utf-8?B?VjNrM0t0Wlk3YzNjaUdGd3dSNnQxYUs4QU9LMGowQWtUeDM3YytLUUoyNU53?=
 =?utf-8?B?OHdvVDZLdE5rb0lIeUhBd00xbmpzTFhOaHl2NkNlYTlaVFZ4WlBCSkhXZ0pK?=
 =?utf-8?B?SWp3UUh6ZlpTMG5wNk5Sazl6SnZuMUNCZW50L0J1aG0zT2oxamR4Q3kwbGdZ?=
 =?utf-8?B?cGVYdzE4V3NLVlJ1MDViZTdKQW16cXNlNnpnc1ZCL1ZCRTNOWTVldz09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324ba153-b964-4e05-37dd-08ded0fd45fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 07:58:55.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYrUOyfNtub6J420cmuGW7Y5UxlwkYmarWkApkGLy1m1hyCXXDvFIlK3buVIxmACR/6Z66NA0FlEaJmGYlrwZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5869

--------------ms070400070903050103030703
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2026-06-15 21:49, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>=20
> The SEV firmware enumerates the CPUs at SNP initialization and is not
> aware of the OS bringing CPUs online or offline afterwards, so OS CPU
> hotplug can diverge from the firmware's expectations and break SNP.
> Disable CPU hotplug while SNP is active.

I think this is too broad. If I have a hypervisor that supports SNP virtu=
alization, a (non-confidential) L1 guest running Linux should still suppo=
rt CPU hotplug while also running confidential L2 guests.

--
Jethro Beekman | CTO | Fortanix

>=20
> SNP is fully torn down only on the SNP_SHUTDOWN_EX x86_snp_shutdown
> path; the legacy path leaves SNP enabled in hardware while clearing
> snp_initialized, so __sev_snp_init_locked() can run again.  Track the
> disable with a flag so it is balanced by a matching enable rather than
> stacked, and re-enable hotplug only on the x86_snp_shutdown path, after=

> snp_shutdown() has cleared the per-core RMPOPT_BASE MSRs with hotplug
> still disabled.
>=20
> This also keeps the CPU set stable for the asynchronous RMPOPT scan
> added later in this series, and ensures cpus_read_lock() in the scan
> is uncontended.
>=20
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.=
c
> index 217b6b19802e..c8c3c577463c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -106,6 +106,9 @@ struct snp_hv_fixed_pages_entry {
> =20
>  static LIST_HEAD(snp_hv_fixed_pages);
> =20
> +/* Set while SNP has CPU hotplug disabled. */
> +static bool snp_cpu_hotplug_disabled;
> +
>  /* Trusted Memory Region (TMR):
>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page all=
ocator
>   *   to allocate the memory, which will return aligned memory for the =
specified
> @@ -1479,6 +1482,17 @@ static int __sev_snp_init_locked(int *error, uns=
igned int max_snp_asid)
> =20
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
> =20
> +	/*
> +	 * Disable CPU hotplug while SNP is active.  Guard against stacking
> +	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
> +	 * snp_initialized without re-enabling hotplug, so this can run
> +	 * again while hotplug is already disabled.
> +	 */
> +	if (!snp_cpu_hotplug_disabled) {
> +		cpu_hotplug_disable();
> +		snp_cpu_hotplug_disabled =3D true;
> +	}
> +
>  	snp_setup_rmpopt();
> =20
>  	sev->snp_initialized =3D true;
> @@ -2083,8 +2097,21 @@ static int __sev_snp_shutdown_locked(int *error,=
 bool panic)
>  	}
> =20
>  	if (data.x86_snp_shutdown) {
> -		if (!panic)
> +		if (!panic) {
>  			snp_shutdown();
> +			/*
> +			 * snp_shutdown() fully tears SNP down (clear_rmp()) and
> +			 * has already cleared the per-core RMPOPT_BASE MSRs via
> +			 * rmpopt_cleanup() with hotplug still disabled.  Re-enable
> +			 * CPU hotplug now.  On the legacy path SNP stays
> +			 * enabled in hardware, so hotplug is correctly left
> +			 * disabled.
> +			 */
> +			if (snp_cpu_hotplug_disabled) {
> +				cpu_hotplug_enable();
> +				snp_cpu_hotplug_disabled =3D false;
> +			}
> +		}
>  		snp_hv_fixed_pages_state_update(sev, ALLOCATED);
>  	} else {
>  		/*


--------------ms070400070903050103030703
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ZmljYXRpb24gQXV0aG9yaXR5IFJTQTAeFw0xOTAzMjYxNzQxMDZaFw0zNDAzMjIxNzQxMDZa
MH4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
A1UECgwIU1NMIENvcnAxOjA4BgNVBAMMMVNTTC5jb20gQ2xpZW50IENlcnRpZmljYXRlIElu
dGVybWVkaWF0ZSBDQSBSU0EgUjIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDm
Q+3UxwVE9dAx75DUrLZwgASWLLr/ID8bbGCfpcrSHIRsrR4ut5n49JGViu5DYE6addkpajbi
MA2Jaw1Ap4RncDjZ+0fzSWbqGKEE+vNPVLoKy7OVIrxf/9HzGUT6YaELSNrGTR0cYNcR+W5b
E3JTxTMQiLMAwBbMXH4qKXQUT+oyIXD11CIMUtM8ECoo2o7qdpw1zaZWwVvhXy9mkAaRgrkw
2NpddZUVbJKF/spsJa3lNVdSi3wcJpDDQAl6jxtBF/3ctkY1OjBQz32yRlArFymsPc+we9ff
HAgvfqbHVfXvgWG8urVith8/6MjmojHMCKqFoJueLbtTPoN8QhvVh49uoRYYAUUH0HOAYCOz
GBGrdJvMIYZqQsX90XlU7Qxp1En7vMkQswkQTvGmBPWrK/EwSAJc15BZm+i8QBxPqVKFORfL
ETLEC4ZrwomtW/oPxBP8zXPvQ0K1dQzAkw+JXxKv/KiwDryFFhU5xMMB3yKxO5NRYXlnqW9n
wfhdBTJScthzAtGO9KZQ2GPmq0NMVMuXe1XdCOmnPxOptKkMldBItkaYgrkTzqP1nzIAhVfU
4sNnHIxKPftwrZ9VMSc5Wkz88bOtAJyz3KQRY0qcAtR4LaeRkiZaEmprQA8EOpdJxtv03pBZ
taUnnTY6DsEwGQ0+P2mmB5IHB74SknyNswIDAQABo4IBaTCCAWUwEgYDVR0TAQH/BAgwBgEB
/wIBADAfBgNVHSMEGDAWgBTdBAkHovV6fVJTEpKV7jiAJQ2mWTCBgwYIKwYBBQUHAQEEdzB1
MFEGCCsGAQUFBzAChkVodHRwOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeS9TU0xjb21Sb290
Q2VydGlmaWNhdGlvbkF1dGhvcml0eVJTQS5jcnQwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3Nw
cy5zc2wuY29tMBEGA1UdIAQKMAgwBgYEVR0gADApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcKAwwwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNv
bS9zc2wuY29tLXJzYS1Sb290Q0EuY3JsMB0GA1UdDgQWBBRmj6a8t5Msnfm6SeVP3OqQUBFq
nTAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAMJr11ncGIPKbaZxuuU2P1TG
yXF+gy+xH2TBNWNliJVL613nH1J7L2WcJQzqXYl77rKTzGeQexnKeYZ13MFwuE80vISif/gw
K569WLoyCvNVvGEZ2bZ+JL5K49mVhrv1gqO+MgMvc8iEENl1xoWRpJGD4EClk8t4u7NUCgBv
hYORiyzHCZcILHcEMvfEwmmFshMN6TqcAJdRjFT0Ru0hJcs5d7EFdM9dCa5ckXWrKK49cSNq
4qOaxqpG99EfDw6U2c70YcJ1/IhC1wL6z8qlGvhYQ0vJvqGJqW/DdeuWcMmrB+qZL9WbORQ1
nvlNggB6smEk0pXXYBr8HYjxT67XwtBBmkBXFpa7G6y4P0BO3kxWGBfvRBJHfyaiwREgVWa3
6V/WjXtPmV8VHcv04Rqgk64E4OlSUxgi9k9VC6kivTXJN+Gg2uJJBQdf+ptVhJqkkrtB0gAB
F+kQP0xsagKkrS3NVrVKo6peWMx0h7l52bGqT8ucu4Qe200KQi2xp/r8jpP60EE9U4M8D1gr
H3Kh9OxVOL4wykdoC/yGJNLKIl0BfsCVWB/GeSq5hxe/84K51OEJqpjDnOMrkRevfVzqGBFF
Aeg7Kg7uSysVR05wR+ltp3ytaIbjGJtKad8raIbM1qiNFErG7YB7v4baI3BP1s/rTDtPLoto
tahwHP7IqOHOMYIFVDCCBVACAQEwgZIwfjELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFz
MRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE6MDgGA1UEAwwxU1NMLmNv
bSBDbGllbnQgQ2VydGlmaWNhdGUgSW50ZXJtZWRpYXRlIENBIFJTQSBSMgIQNfphqrZnvSlG
TcM/9wjbxjANBglghkgBZQMEAgEFAKCCAxIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMjYwNjIzMDc1ODQ2WjAvBgkqhkiG9w0BCQQxIgQgr6pau7zydbgf
0f9G9JEnhnMIUJNuUFUmLFbCVecqd1YwgaMGCSsGAQQBgjcQBDGBlTCBkjB+MQswCQYDVQQG
EwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBD
b3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1lZGlhdGUg
Q0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIGlBgsqhkiG9w0BCRACCzGBlaCBkjB+MQsw
CQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoM
CFNTTCBDb3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1l
ZGlhdGUgQ0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIIBVwYJKoZIhvcNAQkPMYIBSDCC
AUQwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBggqhkiG9w0DAgIB
BTANBggqhkiG9w0DAgIBBTAHBgUrDgMCBzANBggqhkiG9w0DAgIBBTAHBgUrDgMCGjALBglg
hkgBZQMEAgEwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgQwCwYJYIZI
AWUDBAIHMAsGCWCGSAFlAwQCCDALBglghkgBZQMEAgkwCwYJYIZIAWUDBAIKMAsGCSqGSIb3
DQEBATALBgkrgQUQhkg/AAIwCAYGK4EEAQsAMAgGBiuBBAELATAIBgYrgQQBCwIwCAYGK4EE
AQsDMAsGCSuBBRCGSD8AAzAIBgYrgQQBDgAwCAYGK4EEAQ4BMAgGBiuBBAEOAjAIBgYrgQQB
DgMwDQYJKoZIhvcNAQEBBQAEggGAAtD7zSFZlMxbqkhMl5blfMl9cU8mhxsn7lANuxztwXIq
gYSeLIIi2sufaaSxjOgmtyAxU8alFIQoQ8a/PQx+VzL4jYoaLme8PmLPDFbSnJhIq4mab0h9
nm1PVq683eF0DSjrjUItukyQz68su2TFXlCf8t2Fv7IkOdeYl9FpCJEicpUTiLyzpiqJfJMp
//E2eUIfEf/cyN2JdO8oqMO1rpyRq2W4Wb4RokkOxzGosRgkzxFO2OwilPld/+rdTpO0/r3Y
z2AVAVPZmvL2ORwsUDEtWYVGSquUrZ4DEVMCaM4/TO91jasZ30Nw5gMggHTRi4spB9gDY/Aq
2QTu6vusbu7v4/S97esflrH9lFE9Y7XZ48l3gOTi+9679wAVK4nYED8N7m5EZCRXEpu6OmMx
0QbmH+OxXzK2X+1dtF6yieriIkP9NOmBGIuMSdQSwUNPKmp/xN2KGQAxPh6/jizaN4WPpuvC
cIqyOrhCNFbFKQ61NATJEG2z8bCk5xQRS9KCAAAAAAAA

--------------ms070400070903050103030703--
