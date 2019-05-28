Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C229C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 20:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E1F8206C1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 20:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfE1UGo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 16:06:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbfE1UGo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 16:06:44 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SK2aJW048236
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 16:06:43 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ss8u1qex3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 16:06:42 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 28 May 2019 21:06:29 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 28 May 2019 21:06:22 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4SK6L2u48431204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 20:06:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C525D42047;
        Tue, 28 May 2019 20:06:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF4F942042;
        Tue, 28 May 2019 20:06:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.111.38])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 May 2019 20:06:19 +0000 (GMT)
Subject: Re: [PATCH v10 09/12] ima: Implement support for module-style
 appended signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
Date:   Tue, 28 May 2019 16:06:09 -0400
In-Reply-To: <87zhn65qor.fsf@morokweng.localdomain>
References: <20190418035120.2354-1-bauerman@linux.ibm.com>
         <20190418035120.2354-10-bauerman@linux.ibm.com>
         <1557442868.10635.87.camel@linux.ibm.com>
         <87zhn65qor.fsf@morokweng.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052820-0020-0000-0000-00000341594A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052820-0021-0000-0000-00002194571A
Message-Id: <1559073969.4139.38.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280125
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2019-05-28 at 16:23 -0300, Thiago Jung Bauermann wrote:
> Mimi Zohar <zohar@linux.ibm.com> writes:
> 
> > Hi Thiago,
> >
> >> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> >> index fca7a3f23321..a7a20a8c15c1 100644
> >> --- a/security/integrity/ima/ima_policy.c
> >> +++ b/security/integrity/ima/ima_policy.c
> >> @@ -1144,6 +1144,12 @@ void ima_delete_rules(void)
> >>  	}
> >>  }
> >>
> >> +#define __ima_hook_stringify(str)	(#str),
> >> +
> >> +const char *const func_tokens[] = {
> >> +	__ima_hooks(__ima_hook_stringify)
> >> +};
> >> +
> >>  #ifdef	CONFIG_IMA_READ_POLICY
> >>  enum {
> >>  	mask_exec = 0, mask_write, mask_read, mask_append
> >> @@ -1156,12 +1162,6 @@ static const char *const mask_tokens[] = {
> >>  	"MAY_APPEND"
> >>  };
> >>
> >> -#define __ima_hook_stringify(str)	(#str),
> >> -
> >> -static const char *const func_tokens[] = {
> >> -	__ima_hooks(__ima_hook_stringify)
> >> -};
> >> -
> >>  void *ima_policy_start(struct seq_file *m, loff_t *pos)
> >>  {
> >>  	loff_t l = *pos;
> >
> > Is moving this something left over from previous versions or there is
> > a need for this change?
> 
> Well, it's not a strong need, but it's still relevant in the current
> version. I use func_tokens in ima_read_modsig() in order to be able to
> mention the hook name in mod_check_sig()'s error message:
> 
> In ima_read_modsig():
> 
> 	rc = mod_check_sig(sig, buf_len, func_tokens[func]);
> 
> And in mod_check_sig():
> 
> 		pr_err("%s: Module is not signed with expected PKCS#7 message\n",
> 		       name);
> 
> If you think it's not worth it to expose func_tokens, I can make
> ima_read_modsig() pass a more generic const string such as "IMA modsig"
> for example.

This is fine.  I somehow missed moving func_tokens[] outside of the
ifdef was in order to make it independent of "CONFIG_IMA_READ_POLICY".

thanks,

Mimi

