Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4B8C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD2F520720
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="PuGeOex0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKVJp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 17:09:45 -0400
Received: from mail-eopbgr680059.outbound.protection.outlook.com ([40.107.68.59]:13540
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726153AbgFKVJo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 17:09:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdcWm6cVRQWfea8x7pjq7fKA+W7C92OXsoiuxmn2mmpeMVbRswKCkLC6fZ2jqCzfTb9w5m/7my9dEa8ARbXNSOwPQtekRl3VmDz68xq168d65kqxr48Ws97i/9EmJMHY23xsB2Cg4Dr7bYojbkQ+5Jh7JbMbv8EDV989UJYSd6ZplCaEKoucmNEJrYOlVRtbdc1obaFpQR0J1lue8pFNJ757107U6n9ybSFxCgX9uqPNvonuIN5W4QrrdAjQAHWol2prSD4wEMN8r+MW8pZMlngkCJdYYF6cCP91HBkSS6/PV/Rl2HBn7ou++GYWatdRnTwO/k1JIgliPhePQkvw5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5D6V2q2UmKKAfe+Dq2dGSN8I/IJOcqYu2Ai2dZVoTw=;
 b=SltB+rDADT4jmmPceV+CQPVh3l1CU7emGU9sk8d7MmteOHW5oUDhceQPh+33XcbLfYghyP2qogBTF95eIlZ9fc5KaAh9joT3/WPFYe6BwfrllysjdFyOVw47jmai7n6tatgPwWyud0fM10J+2azDDeLvimhd4BPx01xmp9WPT+Cswnvg8/z/u8RkNrsFx4MDTTcSQ6Ta1efjQPHicNMPqEMXB6lhCv2Kgj65XFUphd8cN742Mv/mrAy1fs+x5NWb7m+hJHLm5qg3MBLCrWchHxSk8U6sNH1S2g2nNwOV7WKE59LkZXHTI7qgiAQgeoYTdV1yEvdQnE2g+aXARI9TDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5D6V2q2UmKKAfe+Dq2dGSN8I/IJOcqYu2Ai2dZVoTw=;
 b=PuGeOex07FXmRHW8uGXAV0M122Oj/OT3uKtCzrISBVY75X0RpUPev0bHJirHWP/MeEEj0eYWspm6Ff70IcTNHTBlRgIIIT5zjUvowHsRWfy3cLAlCAT/2szrbcU3W27XysOwbKkPBMPbz960VNwoHMkmzqbMZHUc/1QtpQvgn5I=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1303.namprd12.prod.outlook.com (2603:10b6:903:40::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:09:40 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::39a1:fdeb:b753:e29b]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::39a1:fdeb:b753:e29b%9]) with mapi id 15.20.3088.018; Thu, 11 Jun 2020
 21:09:40 +0000
Subject: Re: [PATCH] crypto: ccp - Fix sparse warnings in sev-dev
To:     Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kbuild test robot <lkp@intel.com>
References: <20200604080941.GA8278@gondor.apana.org.au>
 <20200604090413.GA3850@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3a97ae07-6b99-d27d-dc36-d581e434e5dc@amd.com>
Date:   Thu, 11 Jun 2020 16:09:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200604090413.GA3850@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0057.prod.exchangelabs.com (2603:10b6:800::25) To
 CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0057.prod.exchangelabs.com (2603:10b6:800::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 21:09:39 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eafe7531-3957-4fad-6316-08d80e4bc12d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB13036B3B7E614DF1DD3E64F3EC800@CY4PR12MB1303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKYaDrPnTsqaGlfH3HotnQDQy5/NSHk3JAwlam3JjKnaCz+GkYyozUOBbRjBqRS8jsnZqoWdSLLg7M4f7Uo4VOYPS02Bs1j/pZ99wj4EMxWnJfeVgs/YdQRc1yOJfPjpEzeJdG8AOZ6sSGuitytjrR81u06lg7CIrfy8TxZQsvbbzKcsEL+u4pe4nO06yBdXc41Yu2dYiYayjozjYvaXr9G8GLfo/anP5owAzQIldo5k59EgIehDXlLFRhxdpynQdgksBCpBxs+AAbHtGLGaPff+4fMeyCws83y4vv1feKD6MYt52BOt7KXRe1NU6Z2V3erG5rcL18zxAXOT31H1jIhHTQqBt+GwZsLvLgwDR+NA1LOdu4ctz2LtJEziLwSGkS70f8K05lf1xnP/WNJQ0IuXY9/bzzE5BI0dWENCy4db8NeZ9bBb/sTg0sxExmIDh07UKVvxjsP9uTsC3N1e+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(52116002)(5660300002)(26005)(478600001)(6506007)(83380400001)(66946007)(4326008)(2616005)(31696002)(6512007)(66556008)(86362001)(66476007)(53546011)(45080400002)(956004)(83080400001)(31686004)(8676002)(6486002)(36756003)(966005)(8936002)(16526019)(186003)(54906003)(2906002)(316002)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xlnfFjNoHMI4C8eGx5mRP+jrc5eJKuubZqfPfdehumFT3JZjo+HH0pthBYlS/XZGW9CjumD2Vknqt1FbYWPdipVv31wQVkfXS4Lx0YlZIFVtoLvUsqYGahYSp4XY6XkC1CGDWZ1iXsXnhCB7M6DIzUo5iFDmDLfEILeFGpfqcqEdsTbuJeGiOdh3PuIz9COjz6zsA5oloH9u87LR9VcKI+BW9ckKC6Qdz6dWXYFoZvk+7n0hVixIWdRlmeJKwBA4reOWSYYXy9IKgIhifkdwQQVZfv1YnMDGcQNbBL79IuSHET2zDGFrBomq1jNCdNLSCk/kBfFTA7Xm34qFCr+xNcuthsvrTZfogj1TQftG381QS4Pv2lB2RfBGEfuoox3gQegybuqGQnfxobGg20VWMQJevXSDyCn/CgPOtS6i4BRHsG5vgTyTeQZ1CV8POHH6ps6cirIJ7f+bObXvp8yUGYc9W7U8CeNrDZx5x101CvVQ8wU4LPzU9tc4H3jW53xs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafe7531-3957-4fad-6316-08d80e4bc12d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 21:09:40.1827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrM5chkQwYZAQpY+mvkBUpFNGTOQci1g4Ir7ryOtZ7qPLK+EezVQthRTRtS2SnEPgSDadiHisAQnNPrrkj70OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1303
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/4/20 4:04 AM, Borislav Petkov wrote:
> + Tom.
> 
> On Thu, Jun 04, 2020 at 06:09:41PM +1000, Herbert Xu wrote:
>> This patch fixes a bunch of sparse warnings in sev-dev where the
>> __user marking is incorrectly handled.
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Fixes: 7360e4b14350 ("crypto: ccp: Implement SEV_PEK_CERT_IMPORT...")
>> Fixes: e799035609e1 ("crypto: ccp: Implement SEV_PEK_CSR ioctl...")
>> Fixes: 76a2b524a4b1 ("crypto: ccp - introduce SEV_GET_ID2 command")
>> Fixes: d6112ea0cb34 ("crypto: ccp - introduce SEV_GET_ID2 command")
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 439cd737076e..aa576529283b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -376,6 +376,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>   	struct sev_device *sev = psp_master->sev_data;
>>   	struct sev_user_data_pek_csr input;
>>   	struct sev_data_pek_csr *data;
>> +	void __user *input_address;
>>   	void *blob = NULL;
>>   	int ret;
>>   
>> @@ -394,7 +395,8 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>   		goto cmd;
>>   
>>   	/* allocate a physically contiguous buffer to store the CSR blob */
>> -	if (!access_ok(input.address, input.length) ||
>> +	input_address = (void __user *)input.address;
>> +	if (!access_ok(input_address, input.length) ||
>>   	    input.length > SEV_FW_BLOB_MAX_SIZE) {
>>   		ret = -EFAULT;
>>   		goto e_free;
>> @@ -427,7 +429,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>   	}
>>   
>>   	if (blob) {
>> -		if (copy_to_user((void __user *)input.address, blob, input.length))
>> +		if (copy_to_user(input_address, blob, input.length))
>>   			ret = -EFAULT;
>>   	}
>>   
>> @@ -438,7 +440,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>   	return ret;
>>   }
>>   
>> -void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>> +void *psp_copy_user_blob(u64 uaddr, u32 len)
>>   {
>>   	if (!uaddr || !len)
>>   		return ERR_PTR(-EINVAL);
>> @@ -447,7 +449,7 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>>   	if (len > SEV_FW_BLOB_MAX_SIZE)
>>   		return ERR_PTR(-EINVAL);
>>   
>> -	return memdup_user((void __user *)(uintptr_t)uaddr, len);
>> +	return memdup_user((void __user *)uaddr, len);
>>   }
>>   EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>>   
>> @@ -622,6 +624,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>>   {
>>   	struct sev_user_data_get_id2 input;
>>   	struct sev_data_get_id *data;
>> +	void __user *input_address;
>>   	void *id_blob = NULL;
>>   	int ret;
>>   
>> @@ -633,9 +636,10 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>>   		return -EFAULT;
>>   
>>   	/* Check if we have write access to the userspace buffer */
>> +	input_address = (void __user *)input.address;
>>   	if (input.address &&
>>   	    input.length &&
>> -	    !access_ok(input.address, input.length))
>> +	    !access_ok(input_address, input.length))
>>   		return -EFAULT;
>>   
>>   	data = kzalloc(sizeof(*data), GFP_KERNEL);
>> @@ -667,8 +671,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>>   	}
>>   
>>   	if (id_blob) {
>> -		if (copy_to_user((void __user *)input.address,
>> -				 id_blob, data->len)) {
>> +		if (copy_to_user(input_address, id_blob, data->len)) {
>>   			ret = -EFAULT;
>>   			goto e_free;
>>   		}
>> @@ -727,6 +730,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>   	struct sev_user_data_pdh_cert_export input;
>>   	void *pdh_blob = NULL, *cert_blob = NULL;
>>   	struct sev_data_pdh_cert_export *data;
>> +	void __user *input_cert_chain_address;
>> +	void __user *input_pdh_cert_address;
>>   	int ret;
>>   
>>   	/* If platform is not in INIT state then transition it to INIT. */
>> @@ -752,16 +757,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>   	    !input.cert_chain_address)
>>   		goto cmd;
>>   
>> +	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
>> +	input_cert_chain_address = (void __user *)input.cert_chain_address;
>> +
>>   	/* Allocate a physically contiguous buffer to store the PDH blob. */
>>   	if ((input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) ||
>> -	    !access_ok(input.pdh_cert_address, input.pdh_cert_len)) {
>> +	    !access_ok(input_pdh_cert_address, input.pdh_cert_len)) {
>>   		ret = -EFAULT;
>>   		goto e_free;
>>   	}
>>   
>>   	/* Allocate a physically contiguous buffer to store the cert chain blob. */
>>   	if ((input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) ||
>> -	    !access_ok(input.cert_chain_address, input.cert_chain_len)) {
>> +	    !access_ok(input_cert_chain_address, input.cert_chain_len)) {
>>   		ret = -EFAULT;
>>   		goto e_free;
>>   	}
>> @@ -797,7 +805,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>   	}
>>   
>>   	if (pdh_blob) {
>> -		if (copy_to_user((void __user *)input.pdh_cert_address,
>> +		if (copy_to_user(input_pdh_cert_address,
>>   				 pdh_blob, input.pdh_cert_len)) {
>>   			ret = -EFAULT;
>>   			goto e_free_cert;
>> @@ -805,7 +813,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>   	}
>>   
>>   	if (cert_blob) {
>> -		if (copy_to_user((void __user *)input.cert_chain_address,
>> +		if (copy_to_user(input_cert_chain_address,
>>   				 cert_blob, input.cert_chain_len))
>>   			ret = -EFAULT;
>>   	}
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 7fbc8679145c..49d155cd2dfe 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -597,7 +597,7 @@ int sev_guest_df_flush(int *error);
>>    */
>>   int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>>   
>> -void *psp_copy_user_blob(u64 __user uaddr, u32 len);
>> +void *psp_copy_user_blob(u64 uaddr, u32 len);
>>   
>>   #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>>   
>> -- 
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: https://nam11.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb8a1d59a9c134071943008d80866470a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637268582661190553&amp;sdata=ePa5t%2BDK%2F0k9Hu573nxhLbRL15rR7yXVDek%2BiLn59q0%3D&amp;reserved=0
>> PGP Key: https://nam11.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb8a1d59a9c134071943008d80866470a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637268582661190553&amp;sdata=dWlePUyxRZVnH%2F6RgU%2FA8E3xwKxuJXCviXYLN1SF%2FQs%3D&amp;reserved=0
> 
