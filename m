Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222E8C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 02:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBDEC61622
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 02:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhEKCL3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 22:11:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50170 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231368AbhEKCJp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 22:09:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14B23NBx074635;
        Mon, 10 May 2021 22:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ATqhqjjTMg4j4njri6gaaOT5E4qbVz0G17e30xagr8M=;
 b=ElngkZo2N0rIRlZlPxymLKv2raASVY1JRC4n309+A5RgOkCuTBGRsdYF13whtl+kst1U
 CMPW6zB1ck4afeOeea7+5vuoeL+NcUZtswyYPi87QYDPlyIsRVYQW9w0/PRHhnNmck6N
 lhizIx8279YQ8DUtVpTymhWfI0R7i2v4ZIB22hintDd5HG49RjGrvOnHGCymyPdAYa1V
 G3nMO5FxSju7DGCPhiwtVY1KeC3i5eWiHgT/8eHUv3uksDsflIgGOtZjDb6pAoiaS0Jk
 qT0m3mMJwpmEIEnwmyz+DYA8XZOGzZi18vEGEDt25fghxa24XE34kFh3Lrijro+T9zD8 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ffpdhetp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 22:08:19 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14B23MFH074552;
        Mon, 10 May 2021 22:08:19 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ffpdheta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 22:08:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14B26And004327;
        Tue, 11 May 2021 02:08:18 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 38dj99aktv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 02:08:18 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14B28HBQ32440676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 02:08:17 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46F1F6A047;
        Tue, 11 May 2021 02:08:17 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E10376A054;
        Tue, 11 May 2021 02:08:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.194.217])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 02:08:15 +0000 (GMT)
Message-ID: <f80de91a2771ec25d693a3fc21aefa678dcdaab7.camel@linux.ibm.com>
Subject: Re: [V3 PATCH 09/16] powerpc/pseries/vas: Implement to get all
 capabilities
From:   Haren Myneni <haren@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Date:   Mon, 10 May 2021 19:08:12 -0700
In-Reply-To: <1620626553.7v3m168yl3.astroid@bobo.none>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
         <f6cdf811a29c22056740d48fa3de010f4ea4b848.camel@linux.ibm.com>
         <1620626553.7v3m168yl3.astroid@bobo.none>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s6B4jjo6IQax3iPYzesdIt8R8Nsupw7L
X-Proofpoint-GUID: 1giOvDomr_jDkCEkVUvOfWx18u6M8V6i
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_14:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110013
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2021-05-10 at 16:13 +1000, Nicholas Piggin wrote:
> Excerpts from Haren Myneni's message of April 18, 2021 7:08 am:
> > pHyp provides various VAS capabilities such as GZIP default and QoS
> > capabilities which are used to determine total number of credits
> > available in LPAR, maximum window credits, maximum LPAR credits,
> > whether usermode copy/paste is supported, and etc.
> > 
> > So first retrieve overall vas capabilities using
> > H_QUERY_VAS_CAPABILITIES HCALL which tells the specific features
> > that
> > are available. Then retrieve the specific capabilities by using the
> > feature type in H_QUERY_VAS_CAPABILITIES HCALL.
> > 
> > pHyp supports only GZIP default and GZIP QoS capabilities right
> > now.
> 
> Changelog and title could use a bit of work.
> 
> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> > ---
> >  arch/powerpc/platforms/pseries/vas.c | 130
> > +++++++++++++++++++++++++++
> >  1 file changed, 130 insertions(+)
> > 
> > diff --git a/arch/powerpc/platforms/pseries/vas.c
> > b/arch/powerpc/platforms/pseries/vas.c
> > index 06960151477c..35946fb02995 100644
> > --- a/arch/powerpc/platforms/pseries/vas.c
> > +++ b/arch/powerpc/platforms/pseries/vas.c
> > @@ -30,6 +30,13 @@
> >  /* phyp allows one credit per window right now */
> >  #define DEF_WIN_CREDS		1
> >  
> > +static struct vas_all_capabs capabs_all;
> 
> Does this name come from PAPR? If not, capabilities or caps are
> better 
> for readability than capabs.

No capabs is not from PAPR, I just added capabs as short name for
capabilities. I will change it to caps as suggested.

> 
> > +static int copypaste_feat;
> 
> Should be a bool? And what does it mean? copy-paste is a host core 
> capability.

copypaste_feat can be bool. But is it used to export user space API if
reading all capabilities are successful. 
> 
> > +
> > +struct vas_capabs vcapabs[VAS_MAX_FEAT_TYPE];
> > +
> > +DEFINE_MUTEX(vas_pseries_mutex);
> 
> Can these be made static if they're only used here, and export them
> if a 
> future patch uses them (or add the header declaration now).
> 
> 
> > +
> >  static int64_t hcall_return_busy_check(int64_t rc)
> >  {
> >  	/* Check if we are stalled for some time */
> > @@ -215,3 +222,126 @@ int plpar_vas_query_capabilities(const u64
> > hcall, u8 query_type,
> >  		return -EIO;
> >  	}
> >  }
> > +
> > +/*
> > + * Get the specific capabilities based on the feature type.
> > + * Right now supports GZIP default and GZIP QoS capabilities.
> > + */
> > +static int get_vas_capabilities(u8 feat, enum vas_cop_feat_type
> > type,
> > +				struct vas_ct_capabs_be *capab_be)
> > +{
> > +	struct vas_ct_capabs *capab;
> > +	struct vas_capabs *vcapab;
> > +	int rc = 0;
> > +
> > +	vcapab = &vcapabs[type];
> > +	memset(vcapab, 0, sizeof(*vcapab));
> > +	INIT_LIST_HEAD(&vcapab->list);
> > +
> > +	capab = &vcapab->capab;
> > +
> > +	rc = plpar_vas_query_capabilities(H_QUERY_VAS_CAPABILITIES,
> > feat,
> > +					  (u64)virt_to_phys(capab_be));
> > +	if (rc)
> > +		return rc;
> > +
> > +	capab->user_mode = capab_be->user_mode;
> > +	if (!(capab->user_mode & VAS_COPY_PASTE_USER_MODE)) {
> > +		pr_err("User space COPY/PASTE is not supported\n");
> > +		return -ENOTSUPP;
> > +	}
> > +
> > +	snprintf(capab->name, VAS_DESCR_LEN + 1, "%.8s",
> > +		 (char *)&capab_be->descriptor);
> > +	capab->descriptor = be64_to_cpu(capab_be->descriptor);
> > +	capab->win_type = capab_be->win_type;
> > +	if (capab->win_type >= VAS_MAX_FEAT_TYPE) {
> > +		pr_err("Unsupported window type %u\n", capab-
> > >win_type);
> > +		return -EINVAL;
> > +	}
> > +	capab->max_lpar_creds = be16_to_cpu(capab_be->max_lpar_creds);
> > +	capab->max_win_creds = be16_to_cpu(capab_be->max_win_creds);
> > +	atomic_set(&capab->target_lpar_creds,
> > +		   be16_to_cpu(capab_be->target_lpar_creds));
> > +	if (feat == VAS_GZIP_DEF_FEAT) {
> > +		capab->def_lpar_creds = be16_to_cpu(capab_be-
> > >def_lpar_creds);
> > +
> > +		if (capab->max_win_creds < DEF_WIN_CREDS) {
> > +			pr_err("Window creds(%u) > max allowed window
> > creds(%u)\n",
> > +			       DEF_WIN_CREDS, capab->max_win_creds);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	copypaste_feat = 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int __init pseries_vas_init(void)
> > +{
> > +	struct vas_ct_capabs_be *ct_capabs_be;
> > +	struct vas_all_capabs_be *capabs_be;
> > +	int rc;
> > +
> > +	/*
> > +	 * Linux supports user space COPY/PASTE only with Radix
> > +	 */
> > +	if (!radix_enabled()) {
> > +		pr_err("API is supported only with radix page
> > tables\n");
> > +		return -ENOTSUPP;
> > +	}
> > +
> > +	capabs_be = kmalloc(sizeof(*capabs_be), GFP_KERNEL);
> > +	if (!capabs_be)
> > +		return -ENOMEM;
> > +	/*
> > +	 * Get VAS overall capabilities by passing 0 to feature type.
> > +	 */
> > +	rc = plpar_vas_query_capabilities(H_QUERY_VAS_CAPABILITIES, 0,
> > +					  (u64)virt_to_phys(capabs_be))
> > ;
> > +	if (rc)
> > +		goto out;
> > +
> > +	snprintf(capabs_all.name, VAS_DESCR_LEN, "%.7s",
> > +		 (char *)&capabs_be->descriptor);
> > +	capabs_all.descriptor = be64_to_cpu(capabs_be->descriptor);
> > +	capabs_all.feat_type = be64_to_cpu(capabs_be->feat_type);
> > +
> > +	ct_capabs_be = kmalloc(sizeof(*ct_capabs_be), GFP_KERNEL);
> > +	if (!ct_capabs_be) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +	/*
> > +	 * QOS capabilities available
> > +	 */
> > +	if (capabs_all.feat_type & VAS_GZIP_QOS_FEAT_BIT) {
> > +		rc = get_vas_capabilities(VAS_GZIP_QOS_FEAT,
> > +					  VAS_GZIP_QOS_FEAT_TYPE,
> > ct_capabs_be);
> > +
> > +		if (rc)
> > +			goto out_ct;
> > +	}
> > +	/*
> > +	 * Default capabilities available
> > +	 */
> > +	if (capabs_all.feat_type & VAS_GZIP_DEF_FEAT_BIT) {
> > +		rc = get_vas_capabilities(VAS_GZIP_DEF_FEAT,
> > +					  VAS_GZIP_DEF_FEAT_TYPE,
> > ct_capabs_be);
> > +		if (rc)
> > +			goto out_ct;
> > +	}
> 
> Using the same buffer for two hcalls? Do they fill in different parts
> of 
> it?

Yes, ct_capabs_be buffer is passed to HCALL to get capabilities for DEF
and QOS types. 

Thanks
Haren

> 
> > +
> > +	if (!copypaste_feat)
> > +		pr_err("GZIP feature is not supported\n");
> 
> This is dead code AFAIKS, because errors will always branch to out.
> 
> Thanks,
> Nick
> 
> > +
> > +	pr_info("GZIP feature is available\n");
> > +
> > +out_ct:
> > +	kfree(ct_capabs_be);
> > +out:
> > +	kfree(capabs_be);
> > +	return rc;
> > +}
> > +machine_device_initcall(pseries, pseries_vas_init);
> > -- 
> > 2.18.2
> > 
> > 
> > 

