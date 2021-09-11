Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEDAC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 07:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF786113A
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 07:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhIKHeH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Sep 2021 03:34:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35448 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235349AbhIKHeG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Sep 2021 03:34:06 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18B3vgnZ032125;
        Sat, 11 Sep 2021 07:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=MdN8Jfuvo0fafN88mL3sU7wtiS55Gwf1a8cQll0TNQY=;
 b=whg098Req25wY1VogFS9V/l5y0/wIgy4oitGoNe6TBt1i+CVLEfKE7rmBb++uOKdKrev
 jOIECqMVdSDSyi7hWI7dY77OXl5faZf/lI1Qmq6BSpSknjxgozuuH+ylQLrhcQgHq4ys
 GXCwxfeSJxP11R+kgdwQtfIq1/qAdM7yqI4b994N4ovNgqngcn3cJrvEaNI74DjQFdPw
 9xoCD6f2pw4cVmu7kxSx+sla2KALKypnH1Vvw6S/YHPuw6BLx6QZq6RHPpUYGLhlZ3Yf
 wmy9QBNHtC7BzqbZG+zyKsebHK32Abvm6n5Ixp69r3axrG85KAYj+A2KIjWXKdl59rTH hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=MdN8Jfuvo0fafN88mL3sU7wtiS55Gwf1a8cQll0TNQY=;
 b=uQfw2ionVVv9Ss1NuKwT+hdvlKOIeacXIoicgujG/YV+HFiMdpNFW83RWijOrg3fg0xl
 lGE4LjM2AfxAO4rvVRa8PgNaa6gClPKMuoJ2i6m+jgmkJsAclFpgiB/NhftxdiVgfit2
 3OribFQN+353f6ey3lfnbr4sX2dcGGsgIZlLP5TGc8/fX80vLq9/pla6q19KVOTUWKfj
 s4+AXSn9lyDkQhAj+omVEgRrUv5HFukue9j0Y5YQ0MASBmaFZgLH5tPQq5G0b9DkgBcL
 uWFdvaz0Ld2q5CBoLwjBeVIk3hdCSb5yoIkqgVyEFqLFfj+BbUTh7qDci111e8yeC0Uu 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0n0tr4kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 07:32:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18B7V35H031863;
        Sat, 11 Sep 2021 07:32:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3020.oracle.com with ESMTP id 3b0kshnrmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 07:32:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7byr35Tor0878XzMPl43rj6B8kQfflUvdY3D3Vq90BebmQDYZlu68x9iUiiASYnxqgl16t6uD/2hxJG7t8jGxbwWOToJ52MFaOpxAiY8brOKbIXWosoz/LMBl7qOh+WVwS8OYA0m12O9IcKirdJSVyuIUD1Lot1B8yvIhdIWS+SPDgirlMiQ7eF8zA57CP59Yg4N/IPwCBmUPCXhlCkLf7uH+1c0zRlAqhQmEhSDHIT4ue5Y5yRvkGHzCUAxkzWFOH3GqBFbEGF26mEmcoef+qIoMz6rjixtmGy5EyF6rnpoIXC4ztQoELgf1zUhajDL38tI04Mad0MILUinw9CoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MdN8Jfuvo0fafN88mL3sU7wtiS55Gwf1a8cQll0TNQY=;
 b=fNH83tDAOll59AkI1bBhZJK/OtR9A5RO3rydQ8l7UX5Ij80IL/AvjPg/4rMAuTbQzqXYFS+kU4vx4XD1nSVlDmsOaRk2zpB6oViF1SgehahgcPHtGRpP6XLyNGjpM2jgMjFgl1BpDIfe61UyUYlQ6c1L1GGuWGhiud6/rpawgyzhnDzbMSvQJ9Sl/ikP2zSoi8Ntx7CyPsEdc1EItlSQr3GPlcN3Ji+hWa5HQWCOeY4lBGXcDPjFblmdsTmQjiQ1aTd0xXzsAlRNZ+19qP6fZDrqi3qeO3n5ERMimpCGZbaLdRiXSC/KQhLw0h78iEB2bZaPerNHlY7Er/KX7vE6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdN8Jfuvo0fafN88mL3sU7wtiS55Gwf1a8cQll0TNQY=;
 b=yk/alXh6cOhXiDWj+/K0QXB5aX7YDqu9AB8CZ9/3vNs6vtZvJ48gM6C2Cl5JMjnN/5sR3X/9s2tplUVROu09rBsdWnqDnmmZ3mvZOCJ1UtYgV0rBNiy/+FotsOmOmtsIWFbmKCpq4DqLxQjR3gLUty7xkKjjKe90rXieN7Nr8bU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1950.namprd10.prod.outlook.com
 (2603:10b6:300:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 07:32:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.017; Sat, 11 Sep 2021
 07:32:49 +0000
Date:   Sat, 11 Sep 2021 10:32:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes
 is 0
Message-ID: <20210911073232.GS1935@kadam>
References: <20210908125440.GA6147@kili>
 <YTt/uJjgy4jTr+GL@fedora>
 <YTuAerH3S78Xf1Jc@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTuAerH3S78Xf1Jc@fedora>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0040.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0040.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Sat, 11 Sep 2021 07:32:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6511ee87-8d80-48e6-a7db-08d974f65b0a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB19501CE2726016E7746CCCC58ED79@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXNbj0Cn2+hrS10aKz8SBzPPzk7e3jos/GF5ZTgARBqScmQxJFmliKiBvCsULx5e48IA6Rrmx6xdMcx2AaWbyCV3ZNXsog+VgHSASTzHnabR+ejoKKKOZVf7JKS62BZGvetzhPbuY8x5YXDIq9Oc026V4LrktSp8+//l7Dmf7jcN2giADNNSpRU9uGOarTzijEP//PIvLGtzJpLzOIvHpC1Hxv0Kzs+Q6G/uHXQ/jii9loM0ZOlctBE0Lvwt6J2CqEyLO4PiUshIODceGPYY9TKlTLkbhPS+4JoDz9i5LAOglR3/ST+8eG7gsRN4WI2LB5ROzI3DFj4ywM53/2tktnt6lmAX37IkD/5UumRjll6/6QM+iMISYOS9za+m0epffjb0N+sZrKsCOlioKukFQoQqQMDQdGFABhXKv3sZcx312KVbgfBGFbo8THf2SS+tZ7KBs6ItVfaj5frcd8M4ljRKSnC8/Hm+buwoHzOos/zRrufKPaSBm9tGbpwLREmJOXSyjAJV4dOO+PJ4kRKYE2+wwk3MHiF5usXW82fI/fZ4nEozBtrbJ+4gmCtbkwh/5UZQZ7VU0scK3BguuUmFaPqGh1q/UeJlRQB4MM57Qfp8BspTU92TYkhEQG4qmI2fE/OGfSid2TWLrSADq4RXjU0QS6qfFiOr5SKHQhBLQbmkcOUMW00yyq1+QbGZ/NSzU+2JzDCYpflsgn/KvVsUtIBoVfeumIJuGdlKYqIcHg7sv5xhY6mYugUtivC1xTsfG/fs5009xsGs309vwVnCDSmuglZMgcegX7GmRvWNadE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(26005)(66476007)(66556008)(8676002)(966005)(86362001)(33656002)(8936002)(316002)(83380400001)(478600001)(66946007)(6496006)(9576002)(38100700002)(55016002)(186003)(38350700002)(44832011)(6916009)(1076003)(33716001)(956004)(2906002)(5660300002)(4326008)(9686003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZOrj/gMwAYUT6efJ9H4uCDW3Cy3+K7F/EyIahqEzmOzM3HX03CnXJJdXcO3X?=
 =?us-ascii?Q?16NRHxuFuFDc4GTOaY6rIcY3eMesi1CW4YPRlRnXKh6CC6AUsNCy8BedEQyd?=
 =?us-ascii?Q?5ZG9ZghavHsMk4eAxsvpzIhDmt4EgX00X6cf8cviknPSb8Leqqb9cEO/qOhs?=
 =?us-ascii?Q?xffnlYF8Yd4jpvTNNom64dcUswqZf5u7UT/dqQi6u50MqZb8qdoahO+oo76E?=
 =?us-ascii?Q?2I8x/Tq3AwgarNJdBmjpUxYmJ5PzRVbpxmDom+5hECCrZL/q60/89tA7oDZr?=
 =?us-ascii?Q?OuWtWqFTB1Mno1PGBn5waJAfZefpskbUbxtQBdhAYz2AcX1DwQbeo75F3d3A?=
 =?us-ascii?Q?KFsLdOKYXUgqY43rB7Z+juDJaP26sfN1L+u8xIaao2yGZtfmp+9E17b3L79k?=
 =?us-ascii?Q?ujmd1Z1rC1XSLSesHlEbtG3dgzXCHOnK+dNfDXR6Jgj3N2ootOVvfLi8ikes?=
 =?us-ascii?Q?RWrAbexO6cFA3QBWWhCwf+1ecvDobH6TCRFbAOfdtQXoPgtTC0FKaViL3Gz9?=
 =?us-ascii?Q?PEi7zgVcpyb+KPZ1r48CVDHVq+JSocxe80ZESQ1yYnvFFdVVF+eHPzZJSAMx?=
 =?us-ascii?Q?TjOu0iIpla+GLsTyRqjicJS3N7IdW9pP46gBm4/7ezT5/F71WSw7vyC+2LLO?=
 =?us-ascii?Q?7RW+NX04BjdKBLPpe93r1ObiqFB4KyAvnWF+WlVK4E8eNvlLPJaYOuhWUkwc?=
 =?us-ascii?Q?nwZO8qBoP0KbBhw/oYHn87F3M8WxCqv2qyW8O6g7YIwgQVJVZhrxZd7i5evj?=
 =?us-ascii?Q?Ib9/9AJiPLT4E915TAeof1Kug8RynbpHhG8pNOsnwpbwkbgz851B1lZ4S6EC?=
 =?us-ascii?Q?qw640s1P1LUZKMjNR7o6w8tLZ7d8bQf4EEAFo7vj9IFCTna7KzRu90VTF+Lt?=
 =?us-ascii?Q?JvJ919CPGsMpvMEAbJF+ioLLzOQRdzIJ6f2QBSSKkFCupRxE2feAGKEbik8/?=
 =?us-ascii?Q?7Un3E/XvLYn48DCq608N7kkKRT4rvyvw8TShpc6qsu8gqBbBbzn50qKB+P1K?=
 =?us-ascii?Q?+uqMPSGDpbhTji6qTPieQ5EBvXbgnsRN+7LJKnCmwZZwN1b37PH4Ec3Hcp3e?=
 =?us-ascii?Q?OjppzoQsPZhhN0eGPjy1oLegnIBFoPTy8owVhGEMfpDy5KxHFMl74ue0tz/a?=
 =?us-ascii?Q?8DMq/WIOG4Zom7+WL5d1/9YCEvY5JREx/dpx6WXbKXDprU9QRZ7OlR3kmP1H?=
 =?us-ascii?Q?ToRchOvjNRrui54czLvrj9nM/k/82HgmMZlUS8QcRe2rOulq0sWC+28q7+rS?=
 =?us-ascii?Q?wQN+XYWZyOXD7+cOH4T8c+rkufzWcuFFS3gfYlqd/a6cMnrH/qP4SQvWfIX1?=
 =?us-ascii?Q?JPQwkbOWZUiIHeuVP9tmqpY2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6511ee87-8d80-48e6-a7db-08d974f65b0a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2021 07:32:48.8976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twbqwzlRBb3J93QoNb81wBMJ/nj8IAZ0zEd0jZoSLqmsC5zOD8exNnoHEZUW7a/DHXOFQCNYxlP3Rw1Eu0FdT5h0m54Mk35yiFAMC6FXRTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109110045
X-Proofpoint-GUID: cwj29aTotUU_csy97kqAGCM3kUxEd_73
X-Proofpoint-ORIG-GUID: cwj29aTotUU_csy97kqAGCM3kUxEd_73
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 10, 2021 at 09:27:46PM +0530, Shreyansh Chouhan wrote:
> On Fri, Sep 10, 2021 at 09:24:37PM +0530, Shreyansh Chouhan wrote:
> > Hi Dan,
> > 
> > Sorry for the delay in the response.
> > 
> > On Wed, Sep 08, 2021 at 03:54:40PM +0300, Dan Carpenter wrote:
> > > Hello Shreyansh Chouhan,
> > > 
> > > The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
> > > walk.nbytes is 0" from Aug 22, 2021, leads to the following
> > > Smatch static checker warning:
> > > 
> > > 	arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
> > > 	warn: possible missing kernel_fpu_end()
> > > 
> > > arch/x86/crypto/aesni-intel_glue.c
> > >     839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
> > >     840 {
> > >     841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > >     842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> > >     843         int tail = req->cryptlen % AES_BLOCK_SIZE;
> > >     844         struct skcipher_request subreq;
> > >     845         struct skcipher_walk walk;
> > >     846         int err;
> > >     847 
> > >     848         if (req->cryptlen < AES_BLOCK_SIZE)
> > >     849                 return -EINVAL;
> > >     850 
> > >     851         err = skcipher_walk_virt(&walk, req, false);
> > >     852         if (!walk.nbytes)
> > >     853                 return err;
> > > 
> > > The patch adds this check for "walk.nbytes == 0".
> > > 
> > >     854 
> > >     855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
> > >                                          ^^^^^^^^^^^^^^^^^^^^^^^^
> > > But Smatch says that "walk.nbytes" can be set to zero inside this
> > > if statement.
> > > 
> > 
> > Indeed that is so, I missed it the first time around.
> > 
> > >     856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> > >     857 
> > >     858                 skcipher_walk_abort(&walk);
> > >     859 
> > >     860                 skcipher_request_set_tfm(&subreq, tfm);
> > >     861                 skcipher_request_set_callback(&subreq,
> > >     862                                               skcipher_request_flags(req),
> > >     863                                               NULL, NULL);
> > >     864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > >     865                                            blocks * AES_BLOCK_SIZE, req->iv);
> > >     866                 req = &subreq;
> > >     867 
> > >     868                 err = skcipher_walk_virt(&walk, req, false);
> > >     869                 if (err)
> > >     870                         return err;
> > 
> > We can replace the above if (err) check with another if
> > (!walk.nbytes) check.
> > 
> > >     871         } else {
> > >     872                 tail = 0;
> > >     873         }
> > >     874 
> > >     875         kernel_fpu_begin();
> > >     876 
> > >     877         /* calculate first value of T */
> > >     878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
> > >     879 
> > > 
> > > Leading to not entering this loop and so we don't restore kernel_fpu_end().
> > > 
> > > So maybe the "if (walk.nbytes == 0)" check should be moved to right
> > > before the call to kernel_fpu_begin()?
> > > 
> > 
> > Instead of moving the first walk.nbytes check, I think we can have two if
> > (!walk.nbytes) checks. There was a discussion between Herbert Xu and Ard
> > Biesheuvel, and Herbert wrote in his email that most skcipher walkers are
> > not supposed to explicitly check on the err value, and should instead
> > terminate the loop whenever walk.nbytes is set to 0.
> > 
> > Here is a link to that discussion:
> > 
> > https://lore.kernel.org/linux-crypto/20210820125315.GB28484@gondor.apana.org.au/ 
> > 
> 
> I can send in a patch that replaces the if (err) check with an if
> (!walk.nbytes) check if that is fine with you.
> 

Yes, please!

regards,
dan carpenter

