Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E255650E2;
	Thu, 15 Oct 2026 20:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792095975; cv=fail; b=atbpFkAXN4NGC5csDFkb7QZ8JBTcw2UzBytaF9DhrrdxOlJG6xLupqg6md6I2/StS9w0pVxX2paP/E9xvekL+SD7Qm/6RRzrcVQPEjl0x5wtSuI4XvUwnvaasu7mblbYqazjrSqd8dNJiYxWvV85vg7U4nkmicyNiSLOhUfFhNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792095975; c=relaxed/simple;
	bh=LuiTSuVdUQQyWibfIbLJEOG/uCtmo3B/rJSerNKH93M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UwUm35CnohwEbze58524c1i11oRkcwVg5eAuW+7z93UP/r6wEIgpO48putfd5SfmIyza44LAYfFPp+AQkMRXIc0Ucz0DpHxWCIgW144jTDPP0Zp14+AgBE/rieaVbgk8Obf3sT/pmxaFKQcikdGYUsr4BzHMcvhvkAY9d+jKRm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1XEZfswB reason="signature verification failed"; arc=fail smtp.client-ip=40.93.196.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1XEZfswB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3FT+01/u6bliMTPcErBre6bF0mkEGYGd5FVi+ib6JpmtaPDnfyVfCj0UMu7cKjoOfptDUaXHj1HadDZE+RAGoOHmWnG0X6NASRO8UsWACGF242M46ak6tlAvjNs5cjXkXdo7jGTXQ53MSFUPKEWaan0WK54k2N4tE+t0B3M42eh9TCx1Xurz2jhP8SA6m41ha0KxbNPEnELuyv7+KCjtwP1zjk9BAqIPKhbtHao/QhHSHsLPkkA6zvZ4baNv8WYtcu2WwH9kzWvQP/taTSgXGUhFAMyVKBOSZopC/oQGaBh3TKeW8YZNJrEl2Q2yDe7fck+dP7snthc3TU05I0ukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIhrhRYhWiXVbuVvBbLaM2UZKoe9JP+wgs2TfqwRFiY=;
 b=tgzvhnelzUlGmOGlmH04oVmlXL5zzsmqZCwdIC1Z+0wWatB+ykAyg4gAUlN4NwPY5xOIFXuWAS/ltQa3fZ4eTS3RVNAE7m+qb7dM5Siq/COU5UmjCC6RObR7SyB8ojQtzISbtVxQYK/Obnhl9yGaZzq4KLhiDxTo2M+o0V2sheGBT+BHgJXYSrKoCHjgf5tI80J4VwB7EM/OXjyHMkfT8JxKAHy24KQ0NYs2DWdvrZpAovkriaJSiBGNkSuxmCmGUpZimhEIWkK/i0BmC+Tq9SNdW++yohaQVxNtxmGG759IZJseoPcbByjiKNgpQ/D4gfJGMDREGbeLn39DiTw6xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIhrhRYhWiXVbuVvBbLaM2UZKoe9JP+wgs2TfqwRFiY=;
 b=1XEZfswBtRJsfrFGDbntL3y14D5qm421CEaErP5Wj+Ey213pwy9SYDTjV3veaagb+tlnxXMdn4rUAGmlVLqDHG1cakqumSs4DZrE9xchvmJg9NVtecbu0Jc/MlKYjx2VkU92ht4KW8/EA+ux4dXB2OAWNfzueGMrBaClJpnYJUc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6374.namprd12.prod.outlook.com (2603:10b6:8:a3::18) by
 DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.20; Thu, 15 Oct 2026 20:26:05 +0000
Received: from DM4PR12MB6374.namprd12.prod.outlook.com
 ([fe80::af35:a7a6:6ca:7fcf]) by DM4PR12MB6374.namprd12.prod.outlook.com
 ([fe80::af35:a7a6:6ca:7fcf%5]) with mapi id 15.21.0522.011; Thu, 15 Oct 2026
 20:26:03 +0000
Date: Thu, 15 Oct 2026 16:25:45 -0400
From: Yazen Ghannam <yazen.ghannam@amd.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-crypto@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-mtd@lists.infradead.org, platform-driver-x86@vger.kernel.org,
	linux-fbdev@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Pu Wen <puwen@hygon.cn>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Len Brown <lenb@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	David Airlie <airlied@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Ashok Raj <ashok.raj.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	Helge Deller <deller@gmx.de>, xen-devel@lists.xenproject.org,
	linux-geode@lists.infradead.org,
	Michael Kelley <mhklinux@outlook.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: Re: [PATCH v4 12/13] treewide: convert rdmsrq() from a macro to an
 inline function
Message-ID: <20261015202545.GA1335@yaz-khff2.amd.com>
References: <20261008071839.2247074-1-jgross@suse.com>
 <20261008071839.2247074-13-jgross@suse.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261008071839.2247074-13-jgross@suse.com>
X-ClientProxiedBy: BLAPR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:208:329::14) To DM4PR12MB6374.namprd12.prod.outlook.com
 (2603:10b6:8:a3::18)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6374:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d1fad7-3215-4308-603c-08df2afa88a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9PfaU+CcBdAhpbx/C/NnJ62bGXvju0n9WXba5N2vYW/Bu8MXDfMOwZXmplw0TWe/Xfy9Ue5H/8Vf0eTVqpjapRKvUGEXzvPOAez22EZCKfNUj+KdHstqtOI5QpR+mSJBbcyQps8Zqll4zN8nRwe1HJ94DcT18X92JboGTixnDlCcRU9ssowbjCQ2KXa2plgNFm2pi3WQdvbO02xHhuZ2JTvnuBWrnkG7FtFsUwaZ+oykNG0zjyDQAAN+2Lrw/7auGMjcahOuw/lc5BqDgM1jPPx6ItQv3sOz5IhbK0FNYK/7Kk/CxJgKFLDYvaHdOACx7nP6cPQdkntMLVjoF8qLFcqKWV0K6F5oNaMP++PUFPnUNzUiOc19az/JMRSW4XgADu3veOrqR8ABBdRB/vRR00C765Nt3rjJDHI3NWPM5RsuVkF6lD1AfxSJNtsM4k0KakJxcl1hBJqnACTytU303aKkaKmZep3mk2OkKKYwxlRmvWIAirFvQdEn3grk6XxesUfWNVFmXfhSs+KUPUp0pplmACDruIBXnGcVTAjNLhTaGEh+ZpVT3BBOSI5tP1gsJH2WclliUW8dG/PXBMLV2QDNypOW5tb4RbstTC0+7VGKht/4TndNa+ivB1OsDDqH6E2L9Nve16nMVimFCfUy1u0ZmvIalfkwb0+NwLUdQh8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?BeRIkSzZ8/fzyvoZWeb8eHGmHpJKuigV4R+vAkaFv49Fn23fQylbI0uNN3?=
 =?iso-8859-1?Q?fpDbggTObTiE5LxUHsG6d8QJh3CcDhsPgn64Dgga5DSrUqZ6dbs8yVEbcy?=
 =?iso-8859-1?Q?ToVhD7HSifFwpcnK0MYPy1IVry4tYn8lZA+J5joSdVH5SLfUDBwBy2eRSL?=
 =?iso-8859-1?Q?K3/cQIWz6AvC/PE6dHLxW2qN9QZkcXl5xRCYGwOOm0nmL4XWqFFwfpqw5s?=
 =?iso-8859-1?Q?OFFJbnp2KGlkbrws4YGlB2KUHjNch7UxIp/F2dS+fcLG5vfxg10ih3stde?=
 =?iso-8859-1?Q?9Rq5vvxfjFzCn80wcuPnc1PPlrxxKWTLXeAd9RoKN3tuOVJjYv8scS+hTZ?=
 =?iso-8859-1?Q?AcHWbhAHu7fcc2s7xp7uv8/nFOIDvqDw3XEyyrCrfu2IqSdL+FjhCUK68G?=
 =?iso-8859-1?Q?thi5VN46zxhXIQ1/KMiOXpU7DNwt3b/piu+Adc3ss93lPVFcKAhsYnRn8y?=
 =?iso-8859-1?Q?uPzLtPD2LKdq8ZqIRzMpaQW7lcK9GkQWBVzet8hs2hXdVIjkFdnmLq2Gny?=
 =?iso-8859-1?Q?UGRXokDl88LB83pnRC4r/sgmi40WAemQKGdfqQSbbfGUHLpiW1U+uycR9B?=
 =?iso-8859-1?Q?fYHure4O+uiw1/yS83SyJy1V8kLEOqJaArZsTyWw4+uxiVZ516EVhYhPJ1?=
 =?iso-8859-1?Q?QXrlO+gWLkVMXswJDkj4yvFLfMdCr6Uiv+T74uBUr2+CpW4w/qTmx01W09?=
 =?iso-8859-1?Q?uUhHaKqUBWWckgGA3s4twzSbkVwY1XW3KoUdOmhyiUIOM4byrb94SqE/+D?=
 =?iso-8859-1?Q?8rKoYkE44C3qslEnt724cf7x5vOEJMrrKtNIOwOuOGYu4xitLUzSWMWhmF?=
 =?iso-8859-1?Q?y7H08UTdyS7NtXNPUQMD5vkoi5GFPXkZk3R8MHkvwf1mOMunuyFb3dfmz0?=
 =?iso-8859-1?Q?/3RWD8iDcN9nSnfX+hqhmvnGY7woHILu1WaeLQtFYthZBcAqExmDQHdcAe?=
 =?iso-8859-1?Q?iGYIwBWVXmZJMY3+OcOJYdDd2Dx1eAZR8hHTkL/AeSjpXIJbtaYHOuuAV/?=
 =?iso-8859-1?Q?ZU1GpbrTW8G4MnZOtmvpaq9Nk4oIHU5b8k1R6X+mKm9d2PGEAcwRmk5B62?=
 =?iso-8859-1?Q?bfKAeoS9/JLRLjPB/We6a9uBmgdTnuqUHA/fm986f+qDBWeKlLaresnAVn?=
 =?iso-8859-1?Q?nVqOCuMGAtfhUIPQ7HDtpSgSR21Pcf/kd9eoeU/4Ptfn6DmmtZtK3hnqU5?=
 =?iso-8859-1?Q?7/pHXY2XbCeaV1TtTjAH86iTgQibYp1oTs+F+oYxlHwqZvRYj9s7SqOQXe?=
 =?iso-8859-1?Q?Wtl/Xf1PQ+3l6TY2YE2ggKOHL2M/tTnlynRy7gp+JyNsfYFZTqcQRSQXkx?=
 =?iso-8859-1?Q?pCow6V0A+3Uy5Cqeqo22bL9lVuvFQf98hqLQ/+bE5JZ5ucE/3KtBdoMpeS?=
 =?iso-8859-1?Q?FeVwfdPdamV6QbZXYQZHGtiReIicPhpwDksBlun1d45pzFgd+Froj1hqna?=
 =?iso-8859-1?Q?cDYR72jzbwcneD9UJ6FUscCJtZeqTzOygeRGZBShzSpySFrMAsEjYu1nOz?=
 =?iso-8859-1?Q?A1rB3vGau4ZoahVFx9LU1uQLzTS7HvLOVvAjaehCF1ji5AktbPY/GSnT3x?=
 =?iso-8859-1?Q?zrCbMeAEp4Q8zg4XraJk5DPwTcMXzl2UVoNmRpWuxsnWq371TSpnr5vu+q?=
 =?iso-8859-1?Q?ypy5jxoGKbUorHrN37EcT51lmFSM82PJ82WFVza/E/UxMEe/JlP7aI1JjK?=
 =?iso-8859-1?Q?2I4dtR0PH5kUuPw/llVJQLtxQ6V4v+94mObLpL75Fe+kyTbXKb1ddeCCsB?=
 =?iso-8859-1?Q?xqy8C6ss8VmSAr7ycWz5vykeg04hgUq2wZX5Ykm2C6bDSO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d1fad7-3215-4308-603c-08df2afa88a8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 20:26:03.4850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ffK53pvKIyCwXArrXQKNXAfnhDhCV5QTGz8DhqUVx69qv5dR5B5maC+lw5XHl4AfIutq0lizPx9oZqw6dFEMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

On Thu, Oct 08, 2026 at 09:18:38AM +0200, Juergen Gross wrote:
> Today rdmsrq() is a macro using its second parameter as the target for
> storing the read MSR value.
> 
> Convert rdmsrq() to an inline function returning the MSR value.
> 
> The users have been converted using the following semantic patch:
> 
>   // Options: --include-headers
> 
>   virtual patch
>   virtual report
> 
>   @@
>   expression msr, val;
>   @@
>   (
>   - rdmsrq(msr,val)
>   + val = rdmsrq(msr)
>   )
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org>      # ATA
> Reviewed-by: Michael Kelley <mhklinux@outlook.com> # Hyper-V
> Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org> # ACPI, cpufreq, powercap, thermal
> Acked-by: Sean Christopherson <seanjc@google.com>
> Acked-by: Reinette Chatre <reinette.chatre@intel.com> # resctrl
> Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com> # cpufreq
> Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>		# pdx86
> ---

Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com> # mce, amd64_edac

Thanks,
Yazen
