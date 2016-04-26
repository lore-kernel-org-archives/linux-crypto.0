From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 1/2 v2] crypto: Key-agreement Protocol Primitives API (KPP)
Date: Tue, 26 Apr 2016 10:27:25 +0900
Message-ID: <C7D40AFA-25E0-4E0F-9F2E-10B3380A3C3A@holtmann.org>
References: <1460712316-3127-1-git-send-email-salvatore.benedetto@intel.com> <1460712316-3127-2-git-send-email-salvatore.benedetto@intel.com> <20160426011957.GA16114@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:39971 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751870AbcDZB1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 21:27:33 -0400
In-Reply-To: <20160426011957.GA16114@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>> Add key-agreement protocol primitives (kpp) API which allows to
>> implement primitives required by protocols such as DH and ECDH.
>> The API is composed mainly by the following functions
>> * set_params() - It allows the user to set the parameters known to
>>   both parties involved in the key-agreement session
>> * set_secret() - It allows the user to set his secret, also
>>   referred to as his private key
>> * generate_public_key() - It generates the public key to be sent to
>>   the other counterpart involved in the key-agreement session. The
>>   function has to be called after set_params() and set_secret()
>> * generate_secret() - It generates the shared secret for the session
>> 
>> Other functions such as init() and exit() are provided for allowing
>> cryptographic hardware to be inizialized properly before use
>> 
>> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> 
> I don't have any strong objections to this interface.
> 
> However, I'd like to see it along with an actual user.  Because
> otherwise I'm afraid that I'll soon start receiving patches adding
> drivers using this interface even before we settle on what the
> user interface looks like.  And what the user interface looks
> like is very important because it may impact how we structure
> this.

actually if we have support for ECDH P-256, then Bluetooth could be converted easily and we get an internal user of this API.

Regards

Marcel
