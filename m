Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255DFC4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 17:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6275207F7
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 17:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G9f4LB+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgJERAU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 13:00:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgJERAT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 13:00:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095Gxto5065821;
        Mon, 5 Oct 2020 17:00:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XBtPARSIKTXiJdQhLp8/qu7l+V2KAKByO1/KGEtVIqI=;
 b=G9f4LB+ap0k+b08XCPKj66JzAeMERQ4LjD2/yjMrEUOSagh5LxxNc3XU7wBZZAegWcKn
 6WOtzwikWJ6x7gekf8+t37mwdXOgBkqbp83/j7SkC8Kvva79Ogj4NR9fAHddtvRNr3N7
 m+MR3jADnTx6P0jurE8J4snw2Mqx4evMzdXX2ajIJ3YyNB9udu6gpsmgjmniIo9jr3dT
 RuJxNoApzpLmh5hgliwafXXNOJqh3c5gdVAzwPDG9GfHmZMFeNMmNF9AKX0Pkcsi4gma
 OtEFsGV8wVrX9ST0pup+k0EGP+BOHsboBEZZV1lLOImBo9MPyox7QnvSbWgQjLeEfjJS Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34brx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 17:00:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095GskjV171924;
        Mon, 5 Oct 2020 17:00:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33y36wqtw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 17:00:02 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095H01mK004480;
        Mon, 5 Oct 2020 17:00:01 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 10:00:01 -0700
Date:   Mon, 5 Oct 2020 13:09:10 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, mark.rutland@arm.com,
        jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, tj@kernel.org,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20201005170910.vxwrdwnzlw3ahkb4@ca-dmjordan1.us.oracle.com>
References: <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <e7c92da2-42c0-a97d-7427-6fdc769b41b9@arm.com>
 <20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com>
 <20201001175022.GA22444@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001175022.GA22444@Red>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=2 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=2 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050125
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 01, 2020 at 07:50:22PM +0200, Corentin Labbe wrote:
> On Tue, Mar 03, 2020 at 04:30:17PM -0500, Daniel Jordan wrote:
> > Barring other ideas, Corentin, would you be willing to boot with
> > 
> >     trace_event=initcall:*,module:* trace_options=stacktrace
> > 
> > and
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 33569a01d6e1..393be6979a27 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -3604,8 +3604,11 @@ static noinline int do_init_module(struct module *mod)
> >  	 * be cleaned up needs to sync with the queued work - ie
> >  	 * rcu_barrier()
> >  	 */
> > -	if (llist_add(&freeinit->node, &init_free_list))
> > +	if (llist_add(&freeinit->node, &init_free_list)) {
> > +		pr_warn("%s: schedule_work for mod=%s\n", __func__, mod->name);
> > +		dump_stack();
> >  		schedule_work(&init_free_wq);
> > +	}
> >  
> >  	mutex_unlock(&module_mutex);
> >  	wake_up_all(&module_wq);
> > 
> > but not my earlier fix and share the dmesg and ftrace output to see if the
> > theory holds?
> > 
> > Also, could you attach your config?  Curious now what your crypto options look
> > like after fiddling with some of them today while trying and failing to see
> > this on x86.
> > 
> > thanks,
> > Daniel
> 
> Hello
> 
> Sorry for the very delayed answer.
> 
> I fail to reproduce it on x86 (qemu and  real hw) and arm.
> It seems to only happen on arm64.

Thanks for the config and dmesg, but there's no ftrace.  I see it's not
configured in your kernel, so could you boot with my earlier debug patch plus
this one and the kernel argument initcall_debug instead?

I'm trying to see whether it really is a request module call from the crypto
tests that's triggering this warning.  Preeetty likely that's what's happening,
but want to be sure since I can't reproduce this.  Then I can post the fix.

diff --git a/crypto/algapi.c b/crypto/algapi.c
index fdabf2675b63..0667c6b4588e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -393,6 +393,10 @@ static void crypto_wait_for_test(struct crypto_larval *larval)
 {
 	int err;
 
+	pr_warn("%s: cra_name %s cra_driver_name %s\n", __func__,
+		larval->adult->cra_name, larval->adult->cra_driver_name);
+	dump_stack();
+
 	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
 	if (err != NOTIFY_STOP) {
 		if (WARN_ON(err != NOTIFY_DONE))
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 3cd075ce2a1e..46c4645be763 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -166,6 +166,8 @@ int __request_module(bool wait, const char *fmt, ...)
 	}
 
 	trace_module_request(module_name, wait, _RET_IP_);
+	pr_warn("%s: %s\n", __func__, module_name);
+	dump_stack();
 
 	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 
