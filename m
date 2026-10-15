Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013052.outbound.protection.outlook.com [40.93.196.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD0C43CEF3
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099643; cv=fail; b=p3b1dWInQkHKRpp/jA5wHMfVTShfo1gPYCOW4kVAwLfOmKngne+/86QsO8mBBsTRlED6vbXY7p3yifWBiZdn+tGe6in1qq6J6PYRdrqaTFRN8NLRBhudAjbxHQRsTATSIFphzDa7u9Rqr6PVocfdB57mfk672lM8FEwdWJtrp88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099643; c=relaxed/simple;
	bh=qgNCrMKRQuNx3gY2PHTvVCmG9Bt/PTKZIu4i0nDB9O8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cINz5hL+5offUA5OwQTbVzXLq47OJ/hIhDW17WysPR8GnwTUxoVzeHHHmBmtwROtKw8LlwR3WxsQX0yfE4XQ707byXnjhTnKiBHBu/RvesGpT6sIY8oF0ird+3Vnf1FqDhF4tuChrccoDt1BmiAnuGF9PkqpHEHECIQKB/CxSMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jln0gkQM; arc=fail smtp.client-ip=40.93.196.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jln0gkQM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqzAlJpvjNFoylfI9BCAykX22jPXtWtzlXtB4sBLzah9enkBiteSeYOeGRTsUm1iMNwJFf1E5TlrmJrzOyyJp3ojMUnvK6vrRymGea3RCRZU4785VS6RGGPxqYg65DusafRwM3t8q7OMPQ3kKyorcHpg3xSpsfA4kUBluZHmyn9lDv/E5Dv2mpE3qa5/nv1RwQdn3UfoOMv8aTMyQK2md1i9D4gaLOxcPZJveUQsAdzm3+PkUBD690KHpWVLkv1OKVuhag/o7B4ZCHom0efcG5EyC4kIGom9djMMMYpqRc21goe/H3AqnLyu0XdU7lIOO+Jqzhtvu09sMiagjF6yng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC034ze7QpJHjlyRFR5+yUqQYATn1Kg7FGHonQcP3vg=;
 b=DL3zHd9QoFKspdoaqDkShQSE8mvg4lx4S9cx7OOPMa3HNK1Tcc1QhTIi/ft7Hqz/dAJeP62wAF6yHyJM4oS5EAa0dSTTJE/vuXh8KElYFlhO0jlsCkFChKmhlUCF8XZTh8Yz5UxbXfLAIwH0vShcnMjAxjFOHDo416BJVQ1Z9YLgf9f5u4EF7bJPjoggGJrrces9GgHVNsiUHn7aUGk/7h2z7XkcLydVOA5LDAyR6M6joJdbQUBhmk3z+gPMRQLHgqAklYTrUwYwbG1G+bkpIsTTty7gEWJxZBqyINLQ4MWNiPX2u/HgSRLlOdL8ihH0VQ+aBDavLzaJc0au/Hfssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC034ze7QpJHjlyRFR5+yUqQYATn1Kg7FGHonQcP3vg=;
 b=jln0gkQMKInvAv7gdeQDXTt43hh7vwIbHL9fADxI1SQ+jgqVV0zAmsGnqOK7oiILxBnginC997CCU+/d1j5HSIHwHLcylitO7ebKp24Wva+zNHYalGKNFTIMpcHPu37E23Gdf6Sus2rdlippZxl3iMm3Dvf88cnBhXscB9WARp4=
Received: from BN9PR03CA0620.namprd03.prod.outlook.com (2603:10b6:408:106::25)
 by BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 21:27:15 +0000
Received: from IA0PEPF00000040.namprd04.prod.outlook.com
 (2603:10b6:408:106:cafe::84) by BN9PR03CA0620.outlook.office365.com
 (2603:10b6:408:106::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 21:27:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 IA0PEPF00000040.mail.protection.outlook.com (10.167.249.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 21:27:15 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 16:27:04 -0500
Date: Thu, 15 Oct 2026 16:26:56 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <ashish.kalra@amd.com>, <aik@amd.com>,
	<seanjc@google.com>
Subject: Re: [PATCH 4/4] crypto: ccp - Allocate status page outside
 sev_cmd_mutex in SNP_PLATFORM_STATUS
Message-ID: <bh3qpp3cdnanwgdakflbhp3hnrs7h6p6r447paqyajjmll4gg5@nrj3wgdaf6b7>
References: <20261014132145.1726322-1-michael.roth@amd.com>
 <20261014132145.1726322-5-michael.roth@amd.com>
 <552abfdd-fc3c-4a46-9595-bcc05146f3c6@amd.com>
 <9d145d0d-7d68-4741-b8c2-3db989889a25@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9d145d0d-7d68-4741-b8c2-3db989889a25@amd.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000040:EE_|BY5PR12MB4052:EE_
X-MS-Office365-Filtering-Correlation-Id: 710e3873-efc2-497a-54e1-08df2b031563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|1800799024|36860700016|261009223027099003|56012099006|11063799006|4143699003|260925022911599003|10067099003|18002099003|22082099003|6133799003|260925021911599003|260925021311599003|13003099007;
X-Microsoft-Antispam-Message-Info:
	2/hzUHtZSE52FG97vaN2Y3pjkbrWR+sFc7jKBfHeusGuGg9jGk4f+GvHzTrurR8sRVvTyLciVdw3cnumDW+PDwjby7sj2jPoOKkKEUeeiP1kdmyI7zBowzoBsZ4SU1rKVfs0zzEcyLEgK8Zl117txFXuOZHiPHXtcw5IfJvDeygXid07PpUM2UceP5Vs7YIWqg3YJGVJgGBpN0QcaWhesYIsVun1j6y7GcKmWWtZiaNu1WujuTFJJR5Mdk+9x5sGGlYu7+C0z1J4ff5pK+vCmt+fHHdm3TgNX4n/SZltpegf4Uzr9dG4+fFOao48ScFSsq3H0/7FsR+9umMPQo4PuQzBCXtUMoy/VHBmrm7SQ6i6cYoVd83ceDYImZ20+sTiqNOoHwEyYLuWk4iXdLswykblDRnZLXM4KuTuLWy0MznzoQirKQ+fjOQhdVpYv0SXvfOY1ORYVy/UwBWI8ZTri0TU2usZ3ukGnfw+QRY1XejwdH3STDqLCq6yvWkWhfnoL9x/sEep+q0HJA/GU2rabT5mKjY/ThWC4Fm7CKNwb0VH9tpYvEfFR9Sv7eGUPtDx8n/8xxpTPKJAu1XCcr21gkqiKGo7cQOdfRV6lVw21QAqy6+sHO+Nz5ceidO18qpip99QtmM40cWtgUuML5YoR+nto2LxXYitEDJel56ZXEw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(1800799024)(36860700016)(261009223027099003)(56012099006)(11063799006)(4143699003)(260925022911599003)(10067099003)(18002099003)(22082099003)(6133799003)(260925021911599003)(260925021311599003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SVECBJfCzc+FUaFLnY/0nAZCOOVWPnKc4ZiDhcCkaatKo3c//XBRdsqw6T1TRC2w88aeJPtxrwBvzjoSkOBy7XTm2epevT2zfz6fzsP981jtyEjezl+GxzNrcMgmfjZVu2vQ3iBLtud6B9+8slyvTPFDGqoheSI6e87ftnmRHTdAWdIYEpYuAINg7l4h2Bd/fGzreTKKpb07gfdEdq+VrGyxqoBbRAn0O4RchJDo+Ku0QGfe7gBK/LDh2iXUA7kB5RutiblTRRGz5hjLvyq6+P2cOHN9mxFINZnHKnae361l/h2ffwrxkNq2DuAePpNbO/keLbzh18vBfs9fQwnBhKCHgR3F7HnsSwdtmkjqr+TzHFzilywQQrxZ+/J9cpVBI7CIkfP9mhsvCtfPl/J96fC4WiTrCiNeLMhYr9rjitajLIRsdbQJXTHULAraMwsV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 21:27:15.3286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 710e3873-efc2-497a-54e1-08df2b031563
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000040.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4052

On Thu, Oct 15, 2026 at 03:19:01PM -0400, Pratik R. Sampat wrote:
> 
> On 10/14/26 10:04 AM, Tom Lendacky wrote:
> > On 10/14/26 08:20, Michael Roth wrote:
> >> Allocating memory while holding the global SEV command mutex
> >> (sev_cmd_mutex) unnecessarily blocks concurrent SEV and SNP operations
> >> across the system if page allocation stalls or triggers memory reclaim.
> >>
> >> Rename __sev_do_snp_platform_status() to sev_do_snp_platform_status()
> >> and push the sev_cmd_mutex and firmware call down into a new routine so
> >> that allocation/freeing of the status page can be done outside of the
> >> mutex.
> > 
> > Seems a bit complex. Can you rename __sev_do_snp_platform_status() to
> > sev_do_snp_platform_status() and just put a scoped guard in after the
> > allocation up to just before the "if (ret) goto cleanup"?
> > 
> 
> The DLFW_EX series [1] calls sev_get_api_version() ->
> snp_get_platform_data() -> __sev_do_snp_platform_status() with
> sev_cmd_mutex held, so that the cached platform data is refreshed under
> a single hold of the lock.
> 
> The current split between __sev_do_snp_platform_status() and
> sev_do_snp_platform_status() lets that path reuse the helper with the
> mutex already held, so I'd prefer to keep it.

There's some awkwardness there in that __sev_do_snp_platform_status()
would no longer handle allocating temp page that firmware writes to,
that will have instead been hoisted up into
sev_do_snp_platform_status(), so callers will need to duplicate that
handling (and tracking the 'free' boolean).

So, while that's originally the sort of use-case I had in mind by making
it a separate helper, taking the approach below seems cleaner especially
since it only cares about the sev_user_data_snp_status struct that
sev_do_snp_platform_status() (in this patch) pulls out from the temp
page.

> 
> If we go with Tom's suggestion instead, the single function takes
> sev_cmd_mutex itself. In that case, sev_get_api_version() would have to call
> sev_do_snp_platform_status() before taking the mutex, and pass the result to
> snp_get_platform_data() as an additional struct sev_user_data_snp_status
> parameter. That should be fine, since the cached values only change across a
> firmware update and updates are serialized.
> 
> Either way, whichever series lands second will need to rework
> snp_get_platform_data() for the new helper, and I can help take care of that.

Makes sense. My plan is to send a v2 with Tom's suggestion in place, but
will make sure to rework snp_get_platform_data() if your patches go in
first.

Thanks,

Mike

> 
> [1]: https://lore.kernel.org/linux-crypto/cover.1792014060.git.prsampat@amd.com/
> 
> Thanks
> --Pratik
> 
> > Thanks,
> > Tom
> > 
> >>
> >> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> Signed-off-by: Michael Roth <michael.roth@amd.com>
> >> ---
> >>  drivers/crypto/ccp/sev-dev.c | 60 +++++++++++++++++++++---------------
> >>  1 file changed, 36 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> >> index c8c229a6757c..37b948a81bc9 100644
> >> --- a/drivers/crypto/ccp/sev-dev.c
> >> +++ b/drivers/crypto/ccp/sev-dev.c
> >> @@ -2554,20 +2554,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
> >>  	return ret;
> >>  }
> >>  
> >> -static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> >> -					int *error)
> >> +static int __sev_do_snp_platform_status(void *data, int *error, bool *free)
> >>  {
> >>  	struct sev_device *sev = psp_master->sev_data;
> >>  	struct sev_data_snp_addr buf;
> >> -	struct page *status_page;
> >> -	void *data;
> >>  	int ret;
> >>  
> >> -	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> >> -	if (!status_page)
> >> -		return -ENOMEM;
> >> -
> >> -	data = page_address(status_page);
> >> +	*free = true;
> >>  
> >>  	/*
> >>  	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
> >> @@ -2578,10 +2571,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> >>  		 * Firmware expects the status page to be in Firmware state,
> >>  		 * otherwise it will report an error INVALID_PAGE_STATE.
> >>  		 */
> >> -		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
> >> -			ret = -EFAULT;
> >> -			goto cleanup;
> >> -		}
> >> +		if (rmp_mark_pages_firmware(__pa(data), 1, true))
> >> +			return -EFAULT;
> >>  	}
> >>  
> >>  	buf.address = __psp_pa(data);
> >> @@ -2591,19 +2582,45 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> >>  		/*
> >>  		 * The status page will be in Reclaim state on success, or left
> >>  		 * in Firmware state on failure. Use snp_reclaim_pages() to
> >> -		 * transition either case back to Hypervisor-owned state.
> >> +		 * transition either case back to Hypervisor-owned state. If
> >> +		 * for some reason that fails, it will have been added to the
> >> +		 * leaked pages list, so indicate to the caller to not free
> >> +		 * the page.
> >>  		 */
> >> -		if (snp_reclaim_pages(__pa(data), 1, true))
> >> +		if (snp_reclaim_pages(__pa(data), 1, true)) {
> >> +			*free = false;
> >>  			return -EFAULT;
> >> +		}
> >>  	}
> >>  
> >> +	return ret;
> >> +}
> >> +
> >> +static int sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> >> +				      int *error)
> >> +{
> >> +	struct page *status_page;
> >> +	void *data;
> >> +	bool free;
> >> +	int ret;
> >> +
> >> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> >> +	if (!status_page)
> >> +		return -ENOMEM;
> >> +
> >> +	data = page_address(status_page);
> >> +
> >> +	scoped_guard(mutex, &sev_cmd_mutex)
> >> +		ret = __sev_do_snp_platform_status(data, error, &free);
> >> +
> >>  	if (ret)
> >>  		goto cleanup;
> >>  
> >>  	memcpy(status, data, sizeof(*status));
> >>  
> >>  cleanup:
> >> -	__free_pages(status_page, 0);
> >> +	if (free)
> >> +		__free_pages(status_page, 0);
> >>  	return ret;
> >>  }
> >>  
> >> @@ -2615,8 +2632,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
> >>  	if (!argp->data)
> >>  		return -EINVAL;
> >>  
> >> -	scoped_guard(mutex, &sev_cmd_mutex)
> >> -		ret = __sev_do_snp_platform_status(&status, &argp->error);
> >> +	ret = sev_do_snp_platform_status(&status, &argp->error);
> >>  	if (ret < 0)
> >>  		return ret;
> >>  
> >> @@ -3114,9 +3130,7 @@ static int get_v1_svn(struct sev_device *sev)
> >>  	struct sev_user_data_snp_status status;
> >>  	int ret, error = 0;
> >>  
> >> -	mutex_lock(&sev_cmd_mutex);
> >> -	ret = __sev_do_snp_platform_status(&status, &error);
> >> -	mutex_unlock(&sev_cmd_mutex);
> >> +	ret = sev_do_snp_platform_status(&status, &error);
> >>  	if (ret < 0)
> >>  		return ret;
> >>  
> >> @@ -3131,9 +3145,7 @@ static int get_v2_svn(struct sev_device *sev)
> >>  	struct sev_snp_tcb_version_turin *tcb;
> >>  	int ret, error = 0;
> >>  
> >> -	mutex_lock(&sev_cmd_mutex);
> >> -	ret = __sev_do_snp_platform_status(&status, &error);
> >> -	mutex_unlock(&sev_cmd_mutex);
> >> +	ret = sev_do_snp_platform_status(&status, &error);
> >>  	if (ret < 0)
> >>  		return ret;
> >>  
> > 
> 
