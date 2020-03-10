Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DAAC10DCE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 19:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA29321D56
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 19:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="DFVn6ugy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgCJTxY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 15:53:24 -0400
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:5797
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726729AbgCJTxY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 15:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7dGyTEehY0JKCpCEVcHCjrqzZe5y41pcsckQyYzWToYamlsBYu43l0m3loKeClEKnA1s0XDLcxyUbaH182ZeGUZ0OIAsIIZ7IZaQkpzilxF4taNspYfBmP+0jRSD4WqLaejZAul1FlSKNgau6TWEkl9mDjAmsE2ts5aSQ9/nC1xcP+EXpkreW4rSouWC/2eyjqvwOouEzAPrpFMA+q0f8LIcfMQdBvHf+elKgmQGKovLk6fw/+s5tByQARQfLowhbqAeZLms2ZJUMQqnOuarPEpws8j3JDT7H74cEizLEvONe0UTQhkYmAEBLeBoTKkxbpICF/+aOlHP/TFNW+H8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrywIHVQUEVtfl88/xVt+fLq3mK47sw10aMLPwWgURE=;
 b=PWkLy8tSEK/ZUKiGx/mb584Wk4eE7KVn/uRHo8x4u99UEYnhDQ1O3VdtOKm2yd/Y2HlWtUoVB3QDswqsXfHNTcyAqWEpvZ0cRc/gbXJM/cAtn4FznZZK+mBndC30jL7GZofZHNg1gR+BJp223h2zxaTXiAq463JLbgpCX4GPFOOnMkDdUqZXRIk82sNlv6ciftoaHd3p8gQt/mBT5Y6ceZLeqjq9os1Ac5QwNVyrLTKcDn7N3R7FN+YNmjphJ/pVWVmPywwrDS6qZvcxo+8RyRg2ut/3ZQ9MsIu9hrF+h+pkM/cv1LACQMuIqvsbR6e5WH+/JwF4W0yFPaMvPI0Mhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrywIHVQUEVtfl88/xVt+fLq3mK47sw10aMLPwWgURE=;
 b=DFVn6ugyBhEwlXF5e1Vzskg6Q7B37A777XpZ/dH+Bi5ZLX5/zPnwa6Eb3QWFm/FRa43UKLwrd3mL9CTXze5SQzY7DaJvriKNYRpU4bOxj5nuvE+YEhLT0c4XYbWkm6loH4Yzkc2BAg3+9IH146Yx8Ggt2l9RotYlw7DbffwgiaQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3145.namprd12.prod.outlook.com (2603:10b6:5:3a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 19:53:15 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2793.018; Tue, 10 Mar 2020
 19:53:15 +0000
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl permissions
To:     Connor Kuehl <ckuehl@redhat.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     gary.hook@amd.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, npmccallum@redhat.com, bsd@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200306172010.1213899-1-ckuehl@redhat.com>
 <20200306172010.1213899-2-ckuehl@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <df67f101-383c-ff87-6425-2959e32996fb@amd.com>
Date:   Tue, 10 Mar 2020 14:53:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200306172010.1213899-2-ckuehl@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:3:16::23) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR07CA0037.namprd07.prod.outlook.com (2603:10b6:3:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 19:53:14 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9cc069e6-9c1d-4697-47c6-08d7c52cac01
X-MS-TrafficTypeDiagnostic: DM6PR12MB3145:|DM6PR12MB3145:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB31456FCFB7FD5846A9094B16ECFF0@DM6PR12MB3145.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(199004)(189003)(2616005)(2906002)(5660300002)(26005)(16526019)(186003)(53546011)(31696002)(4326008)(956004)(52116002)(478600001)(316002)(8676002)(6486002)(66556008)(16576012)(8936002)(86362001)(81166006)(81156014)(31686004)(66946007)(36756003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3145;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lboWtnuBE5+2sJrYuqYYLhEMOh5dIWwEiTeDzkBp92pjaz4X5OkobNtl7Oe08+gxmnYNf/T8Kqg8OLESmBUDzMGMRgz0XWnzqQ1MvnKiPuSNZa/fth8+jEqivRQJchal8dS7QI/cPysndr15GP+1qd16CeLBPaDihxn8RhrKtiE0Ohh5f9z2wT8j7X03yCmcXhyQuiQH/Zg2eQhExmUYBJLKqI4eLZ4XqO9Oi490XXX9prpv7YtXygTtoeRFSE1fvi+QxR7amqxwECMkdnf0moysdfQkzWArOGufQF1BowmI2rBkypRwIakPQvV3Faq/Zoeaje426qWazvMFmw94T7YbKuf/h1P8NFlhtSf1EJ7CXsqPfLqqok3SNJbX3PdJlRVmpVDFUmaNbLofyeHUInqVVqlN8i24bWLX4shS0cmhlnZuUpLYjF6u3DCqYrYE
X-MS-Exchange-AntiSpam-MessageData: ZAw6nK/KS/qA+8nCuGSnLI3cilK4BqYt8RSAjPRqdYIH7g3torggOwdhaxVAJpB6zm7r8k5qP13bAUlHAyXuNvL/2DYL35pfdlnuPnmUg4OhxqQbs4M+7BhTV0+bEQz+4E3w2TudIp7/LVqeNUeeCQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc069e6-9c1d-4697-47c6-08d7c52cac01
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 19:53:15.2821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbJ0cN/KKqj1zoJeGKQ3oBIbqhrkNsA5GHFHaB4+8tCZyro6YjggIxoNtwKPHlOkCypnRWU8LTjblVcPT8PeNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3145
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/6/20 11:20 AM, Connor Kuehl wrote:
> Instead of using CAP_SYS_ADMIN which is restricted to the root user,
> check the file mode for write permissions before executing commands that
> can affect the platform. This allows for more fine-grained access
> control to the SEV ioctl interface. This would allow a SEV-only user
> or group the ability to administer the platform without requiring them
> to be root or granting them overly powerful permissions.
> 
> For example:
> 
> chown root:root /dev/sev
> chmod 600 /dev/sev
> setfacl -m g:sev:r /dev/sev
> setfacl -m g:sev-admin:rw /dev/sev
> 
> In this instance, members of the "sev-admin" group have the ability to
> perform all ioctl calls (including the ones that modify platform state).
> Members of the "sev" group only have access to the ioctls that do not
> modify the platform state.
> 
> This also makes opening "/dev/sev" more consistent with how file
> descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
> the file descriptor could be opened read-only but could still execute
> ioctls that modify the platform state. This patch enforces that the file
> descriptor is opened with write privileges if it is going to be used to
> modify the platform state.
> 
> This flexibility is completely opt-in, and if it is not desirable by
> the administrator then they do not need to give anyone else access to
> /dev/sev.
> 
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e467860f797d..416b80938a3e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -283,11 +283,11 @@ static int sev_get_platform_state(int *state, int *error)
>  	return rc;
>  }
>  
> -static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
>  {
>  	int state, rc;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	/*
> @@ -331,12 +331,12 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	int rc;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	if (sev->state == SEV_STATE_UNINIT) {
> @@ -348,7 +348,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
>  	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>  }
>  
> -static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_csr input;
> @@ -356,7 +356,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
>  	void *blob = NULL;
>  	int ret;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> @@ -539,7 +539,7 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_cert_import input;
> @@ -547,7 +547,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
>  	void *pek_blob, *oca_blob;
>  	int ret;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!writable)
>  		return -EPERM;
>  
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> @@ -698,7 +698,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
> +static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pdh_cert_export input;
> @@ -708,7 +708,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
>  
>  	/* If platform is not in INIT state then transition it to INIT. */
>  	if (sev->state != SEV_STATE_INIT) {
> -		if (!capable(CAP_SYS_ADMIN))
> +		if (!writable)
>  			return -EPERM;
>  
>  		ret = __sev_platform_init_locked(&argp->error);
> @@ -801,6 +801,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	void __user *argp = (void __user *)arg;
>  	struct sev_issue_cmd input;
>  	int ret = -EFAULT;
> +	bool writable = file->f_mode & FMODE_WRITE;
>  
>  	if (!psp_master || !psp_master->sev_data)
>  		return -ENODEV;
> @@ -819,25 +820,25 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	switch (input.cmd) {
>  
>  	case SEV_FACTORY_RESET:
> -		ret = sev_ioctl_do_reset(&input);
> +		ret = sev_ioctl_do_reset(&input, writable);
>  		break;
>  	case SEV_PLATFORM_STATUS:
>  		ret = sev_ioctl_do_platform_status(&input);
>  		break;
>  	case SEV_PEK_GEN:
> -		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
> +		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input, writable);
>  		break;
>  	case SEV_PDH_GEN:
> -		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
> +		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input, writable);
>  		break;
>  	case SEV_PEK_CSR:
> -		ret = sev_ioctl_do_pek_csr(&input);
> +		ret = sev_ioctl_do_pek_csr(&input, writable);
>  		break;
>  	case SEV_PEK_CERT_IMPORT:
> -		ret = sev_ioctl_do_pek_import(&input);
> +		ret = sev_ioctl_do_pek_import(&input, writable);
>  		break;
>  	case SEV_PDH_CERT_EXPORT:
> -		ret = sev_ioctl_do_pdh_export(&input);
> +		ret = sev_ioctl_do_pdh_export(&input, writable);
>  		break;
>  	case SEV_GET_ID:
>  		pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
> 
