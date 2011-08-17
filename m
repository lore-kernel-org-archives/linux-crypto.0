From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [RFC v1.1 2/5] crypto: ksign - digital signature verification
 support
Date: Wed, 17 Aug 2011 13:54:16 +0300
Message-ID: <4E4B9DD8.3060303@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <8abcf5f23fc65590340f51399fc2d60cf4e62f30.1313082284.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1108161059260.7706@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:28341 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821Ab1HQKxG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 06:53:06 -0400
In-Reply-To: <alpine.LRH.2.00.1108161059260.7706@tundra.namei.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 16/08/11 04:00, James Morris wrote:
> On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:
>
>> +static int ksign_verify_rsa(struct key *key,
>> +		    const char *sig, int siglen,
>> +		       const char *h, int hlen)
>> +{
>> +	int err = -ENOMEM;
>> +	unsigned long len;
>> +	unsigned long mlen, mblen;
>> +	unsigned nret, l;
>> +	int valid, head, i;
>> +	unsigned char *out1 = NULL, *out2 = NULL;
>> +	MPI in = NULL, res = NULL, pkey[2];
>> +	uint8_t *p, *datap, *endp;
>> +	struct user_key_payload *ukp;
>> +	struct pubkey_hdr *pkh;
>> +
>> +	down_read(&key->sem);
>> +	ukp = key->payload.data;
>> +	pkh = (struct pubkey_hdr *)ukp->data;
>> +
>> +	if (pkh->version != 1)
>> +		return -EINVAL;
>> +
>> +	if (pkh->algo != PUBKEY_ALGO_RSA)
>> +		return -EINVAL;
> Are you supposed to be still holding key->sem here?
>
Of course not.
that was late addition. Should be goto as in following cases...

- Dmitry
