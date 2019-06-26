Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C86C48BD6
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 00:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2300B20665
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 00:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfFZANb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 20:13:31 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:41771 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725782AbfFZANb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 20:13:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 43DC71822495E;
        Wed, 26 Jun 2019 00:13:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: event25_10e35e383f0f
X-Filterd-Recvd-Size: 3739
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Wed, 26 Jun 2019 00:13:27 +0000 (UTC)
Message-ID: <983486e9b2daaa34f84f99a890fcedfeae22b24f.camel@perches.com>
Subject: Re: [PATCH v2 2/2] crypto: doc - Fix formatting of new crypto
 engine content
From:   Joe Perches <joe@perches.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Tue, 25 Jun 2019 17:13:25 -0700
In-Reply-To: <156150622886.22527.934327975584441429.stgit@taos>
References: <156150616764.22527.16524544899486041609.stgit@taos>
         <156150622886.22527.934327975584441429.stgit@taos>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2019-06-25 at 23:43 +0000, Hook, Gary wrote:
> Tidy up the formatting/grammar in crypto_engine.rst. Use bulleted lists
> where appropriate.

Hi again Gary.

> diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
[]
> +Before transferring any request, you have to fill the context enginectx by
> +providing functions for the following:
> +
> +* ``prepare_crypt_hardware``: Called once before any prepare functions are
> +  called.
> +
> +* ``unprepare_crypt_hardware``: Called once after all unprepare functions have
> +  been called.
> +
> +* ``prepare_cipher_request``/``prepare_hash_request``: Called before each
> +  corresponding request is performed. If some processing or other preparatory
> +  work is required, do it here.
> +
> +* ``unprepare_cipher_request``/``unprepare_hash_request``: Called after each
> +  request is handled. Clean up / undo what was done in the prepare function.
> +
> +* ``cipher_one_request``/``hash_one_request``: Handle the current request by
> +  performing the operation.

I again suggest not using ``<func>`` but instead use <func>()
and remove unnecessary blank lines.

i.e.:

* prepare_crypt_hardware(): Called once before any prepare functions are
  called.
* unprepare_crypt_hardware():  Called once after all unprepare functions
  have been called.
* prepare_cipher_request()/prepare_hash_request(): Called before each
  corresponding request is performed. If some processing or other preparatory
  work is required, do it here.
* unprepare_cipher_request()/unprepare_hash_request(): Called after each
  request is handled. Clean up / undo what was done in the prepare function.
* cipher_one_request()/hash_one_request(): Handle the current request by
  performing the operation.

[]
> +When your driver receives a crypto_request, you must to transfer it to
> +the crypto engine via one of:
> +
> +* crypto_transfer_ablkcipher_request_to_engine()

And removing the unnecessary blank lines below

> +
> +* crypto_transfer_aead_request_to_engine()
> +
> +* crypto_transfer_akcipher_request_to_engine()
> +
> +* crypto_transfer_hash_request_to_engine()
> +
> +* crypto_transfer_skcipher_request_to_engine()
> +
> +At the end of the request process, a call to one of the following functions is needed:
> +
> +* crypto_finalize_ablkcipher_request()
> +
> +* crypto_finalize_aead_request()
> +
> +* crypto_finalize_akcipher_request()
> +
> +* crypto_finalize_hash_request()
> +
> +* crypto_finalize_skcipher_request()


