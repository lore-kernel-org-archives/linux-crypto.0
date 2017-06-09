From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Can someone check linux kernel 4.4, and 4.9 rfc4309 test vectors?
Date: Fri, 9 Jun 2017 12:00:48 +0530
Message-ID: <CAFXBA=kX=MmdrMKPQEN=gjFqCgEovPet+o3em-xpQZqidxXbFg@mail.gmail.com>
References: <cd81c137faef49999fbd6da538132b03@NALASEXR01F.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Zhen Kong <zkong@quicinc.com>,
        Dan Bronstein <dbronste@qti.qualcomm.com>
To: Che-Min Hsieh <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38591 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdFIGau (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2017 02:30:50 -0400
Received: by mail-wm0-f47.google.com with SMTP id n195so43519017wmg.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jun 2017 23:30:49 -0700 (PDT)
In-Reply-To: <cd81c137faef49999fbd6da538132b03@NALASEXR01F.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 7, 2017 at 7:27 PM, Che-Min Hsieh <cheminh@qti.qualcomm.com> wrote:
> Rfc4309 test vectors in testmgr.h have gone through major changes from linux3  to linux4.
> In linux 4.4, linux4.9, there are vectors as such
>
> 23194 static struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
> 23195    { /* Generated using Crypto++ */
> 23196                    .key       = zeroed_string,
> 23197                    .klen      = 19,
> 23198                    .iv           = zeroed_string,
> 23199                    .input    = zeroed_string,
> 23200                    .ilen       = 16,
> 23201                    .assoc    = zeroed_string,
> 23202                    .alen      = 16,
> 23203                    .result   = "\x2E\x9A\xCA\x6B\xDA\x54\xFC\x6F"
> 23204                                      "\x12\x50\xE8\xDE\x81\x3C\x63\x08"
> 23205                                      "\x1A\x22\xBA\x75\xEE\xD4\xD5\xB5"
> 23206                                      "\x27\x50\x01\xAC\x03\x33\x39\xFB",
> 23207                    .rlen       = 32,
>
>
> I have a test program using open ssl API (-l crypto), and run on Ubuntu Linux PC,   I  get the following  test result:
>
> 2e 9a ca 6b da 54 fc 6f 12 50 e8 de 81 3c 63 08
> fb 64 91 b4 dd dc bf 5d fd 67 e3 a2 f8 7c 0e 6c
>               The first part of encrypted text is correct. But MAC is not the same.
>
> My program is as the following:
>
> void ccmTest()
> {
>     /* Initialization */
>     EVP_CIPHER_CTX ctx;
>     EVP_CIPHER_CTX *cryptCtx = &ctx;
>     EVP_CIPHER_CTX_init(cryptCtx);
>     int i;
>
>    unsigned char P[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
>     int Psize = sizeof(P);
>     unsigned char K[16] = {0};
>     unsigned char N[11] = {0};
>     unsigned char A[16] = {0};
>     unsigned char CT[128];
>
>     int Nsize = 11;
>     int Tsize = 16;
>
>     // Initialize the context with the alg only
>     EVP_EncryptInit(cryptCtx, EVP_aes_128_ccm(), 0, 0);
>
>     // Set nonce and tag sizes
>     EVP_CIPHER_CTX_ctrl(cryptCtx, EVP_CTRL_CCM_SET_IVLEN, Nsize, 0);
>     EVP_CIPHER_CTX_ctrl(cryptCtx, EVP_CTRL_CCM_SET_TAG, Tsize, 0);
>
>     // Finally set the key and the nonce
>     EVP_EncryptInit(cryptCtx, 0, K, N);
>
>     // Tell the alg we will encrypt Psize bytes
>     int outl = 0;
>     EVP_EncryptUpdate(cryptCtx, 0, &outl, 0, sizeof(P));
>    // Add the AAD
>     EVP_EncryptUpdate(cryptCtx, 0, &outl, A, sizeof(A));
>    // Now we encrypt the data in P, placing the output in CT
>     EVP_EncryptUpdate(cryptCtx, CT, &outl, P, Psize);
>     EVP_EncryptFinal(cryptCtx, &CT[outl], &outl);
>     // Append the tag to the end of the encrypted output
>     EVP_CIPHER_CTX_ctrl(cryptCtx, EVP_CTRL_CCM_GET_TAG, Tsize, &CT[Psize]);
>     hexdump(CT, Tsize+Psize);
> }
>
>
> I run "insmod tcrypt.ko mode=45"  rfc4309 test with Qualcomm crypto hardware on Linux4.4. The test fails. The generated output is the same as my openSSL test application in 1.
Older kernel driver also includes IV in Authentication data.  Thats
why MAC is wrong . 4.4 kernel crypto drivers don't need to include IV
in authentication data. Updating driver not to include IV string in
authentication data for latest kernels should work.
>
> My test application runs on Ubuntu with linux 3.10 rfc4309 test vector, and generated MAC as expected from test vectors.  Qualcomm crypto hardware runs "insmod tcrypt.ko mode=45" successfully with linux 3.10.
>
> I am suspicious about the test vectors of 4.4. Can someone verify the Linux 4.4 rfc4309 test vectors with his/her openSSL application on PC?
>
> Chemin
