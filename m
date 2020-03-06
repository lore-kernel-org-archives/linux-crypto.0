Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACB1C10F25
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 16:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6444A2073D
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 16:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FqzPkzNz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgCFQMY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:12:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46758 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgCFQMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Mar 2020 11:12:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026FwRdY010762;
        Fri, 6 Mar 2020 16:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a2clhmmmya55OinwgvvRajQ5WwlmesIYpOf+oPKPgQM=;
 b=FqzPkzNz52Gafw2/hwj9LD1WFKN/LywIRe5GZZThqIqeUx74TZ6SejHQ1W1F48OEMd+m
 j8RPR+9YHdBVF95jNvCFmYJkJUYI+BZtWE9lcH0c/npv5/eCByu/5UkMS+M9EfL2udXg
 pa74fajfUbfAQEyImcEamjtq/J2Dfax9AwuaBpsLv65v5/R1s9AQzpcs2CN5Hg5+dT/P
 tPvRSQEYruQnCIS96W3MJmj4VN4i+F0hmFlG/XIVF8mf3ny7JFrzdhISSa6kcgsPSimc
 rrC/oEBZ+xD+tyPSbCaokafhor3D/2VHxoPO/jF9pUcWh3+Pigz7d7B/whr4vaNtEbxs og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ykgys2rkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 16:12:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026FvUOh156456;
        Fri, 6 Mar 2020 16:12:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yg1pdp0wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 16:12:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 026GC54e032096;
        Fri, 6 Mar 2020 16:12:05 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Mar 2020 08:12:04 -0800
Date:   Fri, 6 Mar 2020 11:12:22 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, mark.rutland@arm.com,
        jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, tj@kernel.org,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200306161222.wsx6nx26f7u7vabf@ca-dmjordan1.us.oracle.com>
References: <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <e7c92da2-42c0-a97d-7427-6fdc769b41b9@arm.com>
 <20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com>
 <20200303224327.GA89804@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303224327.GA89804@sol.localdomain>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060110
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 03, 2020 at 02:43:27PM -0800, Eric Biggers wrote:
> Probably the request_module() is coming from the registration-time crypto
> self-tests allocating the generic implementation of algorithm when an
> architecture-specific implementation is registered.  This occurs when
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on Linux v5.2 and later.

Ok, I can confirm that if we get the debug output from one of Corentin's
boards.

> If this is causing problems we could do:
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index ccb3d60729fc..d89791700b88 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1667,7 +1667,7 @@ static int test_hash_vs_generic_impl(const char *driver,
>  	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
>  		return 0;
>  
> -	generic_tfm = crypto_alloc_shash(generic_driver, 0, 0);
> +	generic_tfm = crypto_alloc_shash(generic_driver, 0, CRYPTO_NOLOAD);
>  	if (IS_ERR(generic_tfm)) {
>  		err = PTR_ERR(generic_tfm);
>  		if (err == -ENOENT) {
> @@ -2389,7 +2389,7 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
>  	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
>  		return 0;
>  
> -	generic_tfm = crypto_alloc_aead(generic_driver, 0, 0);
> +	generic_tfm = crypto_alloc_aead(generic_driver, 0, CRYPTO_NOLOAD);
>  	if (IS_ERR(generic_tfm)) {
>  		err = PTR_ERR(generic_tfm);
>  		if (err == -ENOENT) {
> @@ -2993,7 +2993,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
>  	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
>  		return 0;
>  
> -	generic_tfm = crypto_alloc_skcipher(generic_driver, 0, 0);
> +	generic_tfm = crypto_alloc_skcipher(generic_driver, 0, CRYPTO_NOLOAD);
>  	if (IS_ERR(generic_tfm)) {
>  		err = PTR_ERR(generic_tfm);
>  		if (err == -ENOENT) {
> 
> 
> ... but that's not ideal, since it would mean that if someone builds all crypto
> algorithms as modules, then the comparison tests could be unnecessarily skipped.

We should try to avoid this then.

> But it is really always wrong to be calling request_module() from other
> module_init() functions?  The commit that added 'init_free_wq' was also
> introduced in v5.2; maybe that's the problem here?
> 
> 	commit 1a7b7d9220819afe79d1ec5d759fe4349bd2453e
> 	Author: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 	Date:   Thu Apr 25 17:11:37 2019 -0700
> 
> 	    modules: Use vmalloc special flag

Yes, I don't see a reason init_free_wq has to be initialized that late.
