Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BD53D6F
	for <linux-crypto@vger.kernel.org>; Tue,  9 Sep 2025 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757426517; cv=none; b=h4Rt06kySVbydIWvavNHy/7kxjzxBCyLtaSsTp0DmmLGe4dGA2NrChAJ9+QZOibksHQsl125fGANzGBqJsTbokqs7vQtoFVtHpM1O/XbGjaJIddPgNnW0MrkDvG7tBeufrosD6enOzzqUfp9K+8aGtNOwDc81M8Ijc2+WpOZtBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757426517; c=relaxed/simple;
	bh=6C8ElmIub2k6lXzmOHY17p3WD3C4rHjaFNGjotn9Iys=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=AOU76A+eqKdw1+wyBGyaHI5vJlbo1J9bBm3vcaEUYD87F/YIMgCK8m83ICxLbXXFA75KuYMtBiUZ7ZgQx0VADSH5z22rRiA0oAMli5SCKyDlEoLj5DYAu5nM6fiaTB2rqKqNbe5BiyOBLZezYSGorza6PP4a8/TbTAaaF0pBc80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Szr7zFLT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Szr7zFLT"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589A5L2S024558;
	Tue, 9 Sep 2025 14:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=1oB99sJa5huwmIPGBsMPYS4KUtbgh5PZNH5HS+WEX84=; b=Szr7zFLTqw+6
	QXaZtWVn0jyCkKeO20+TXfEBa2n9T7FbdF+PG+e0How8UlKbLRaDepw0uUQVImJC
	6JCJeiSTC43U+a/6+4He+uMk7Mpgs/cPfuC6RbDJXE+gck7HQnj/Wl+9e3kz86Sw
	2i1xHtI+OoeJoQPk64BHWIAkJHOUKr0h0lUNI8wACLRlKYTOQW833jAQHJWJ64Gw
	4kaTvYQ+N12i7buzdeSs0vnXnezFrWi2MCa1aUiQh2BGHzDP6r9nDU8n8oWD8pzX
	xujYs/uRKpqd4noZa433XjKzUQXyLQs9QDCibUIh/xX8PCEO90m4Ym9bD6jIJDO/
	8Du70zLPdA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwr82j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:01:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589Cr7IG011428;
	Tue, 9 Sep 2025 14:01:47 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9ubpnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:01:47 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589E1ktx29622880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 14:01:46 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 492A658065;
	Tue,  9 Sep 2025 14:01:46 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02F1658055;
	Tue,  9 Sep 2025 14:01:46 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 14:01:45 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 09 Sep 2025 16:01:45 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        dm-devel@lists.linux.dev
Subject: Re: crypto ahash requests on the stack
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com>
References: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com>
Message-ID: <b20529cc85868607dbec25489daa0404@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -cGbKbW65Ijn3sOW-2H-PdPXwUu7De5y
X-Proofpoint-ORIG-GUID: -cGbKbW65Ijn3sOW-2H-PdPXwUu7De5y
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c0334d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=QsnAe65qxYrXraXQVr8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfXxSXhp31a0PP6
 FvfupsUrAhsrXseEdbgfxKlJCYJH5/oKv2ltqNyHbdOZ867ikbGg4wVR5igiBwl8DG2cLE1iT2A
 3zoo9Mg4zCqo7Fc3mU614U0eiGITYeFAAmTbCEESjh5jJ3Hcqwk6QOOTH+9CK/uB/R1arAGEpTd
 bGI3Ffw1FQstYYjEII4DblPFVhTqtGtVFFJqyzmZfsc2hNqF8LEAi+8Vmz7uXPukQv2CDFkXNDa
 lJ5Mbm6kqNCk37FBCN6e6ge0ueezDzUUXp2jpGkwjxG/Qhy5zxAoE68HITp0E56cAJt+CbhQ9Yc
 hMMnT4N4PkDlCqUkC7zC710gXhO/W/29jOwTlGaYrcmCSg9NC1+pmWAn3w/p8q/sweW0129TeO0
 lVCXbAnH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

On 2025-08-25 16:23, Mikulas Patocka wrote:
> Hi
> 
> I'd like to ask about this condition in crypto_ahash_digest:
> 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> 		return -EAGAIN;
> 
> Can it be removed? Or, is there some reason why you can't have
> asynchronous requests on the stack (such as inability of doing DMA to
> virtually mapped stack)?
> 
> Or, should I just clear the flag CRYPTO_TFM_REQ_ON_STACK in my code?
> 
> I'm modifying dm-integrity to use asynchronous API so that Harald
> Freudenberger can use it on mainframes (the reason is that his
> implementation only provides asynchronous API) and I would prefer to 
> place
> ahash requests on the stack (and wait for them before the function 
> exits).
> 
> The commit 04bfa4c7d5119ca38f8133bfdae7957a60c8b221 says that we should
> clone the request with HASH_REQUEST_CLONE, but that is not usable in
> dm-integrity, because dm-integrity must work even when the system is 
> out
> of memory.
> 
> Mikulas

The problem with this 'on the stack' is also with the buffer addresses.
The asynch implementations get scatterlists. By playing around there,
I found out that the addresses in scatterlists are checked:

scatterlist.h:

static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
			      unsigned int buflen)
{
#ifdef CONFIG_DEBUG_SG
	BUG_ON(!virt_addr_valid(buf));
#endif
	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
}

and virt_addr_valid(x) fails on stack addresses (!). I talked with the
s390 subsystem maintainer and he confirms this. So stack addresses can't
be used for scatterlists even when there is no DMA involved.

Harald Freudenberger
