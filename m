From: Che-Min Hsieh <cheminh@qti.qualcomm.com>
Subject: Can someone check linux kernel 4.4, and 4.9 rfc4309 test vectors?
Date: Wed, 7 Jun 2017 13:57:31 +0000
Message-ID: <cd81c137faef49999fbd6da538132b03@NALASEXR01F.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Zhen Kong <zkong@quicinc.com>,
        Dan Bronstein <dbronste@qti.qualcomm.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20798 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdFGN6U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 09:58:20 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rfc4309 test vectors in testmgr.h have gone through major changes from linu=
x3  to linux4.
In linux 4.4, linux4.9, there are vectors as such

23194 static struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] =3D {
23195    { /* Generated using Crypto++ */
23196                    .key       =3D zeroed_string,
23197                    .klen      =3D 19,
23198                    .iv           =3D zeroed_string,
23199                    .input    =3D zeroed_string,
23200                    .ilen       =3D 16,
23201                    .assoc    =3D zeroed_string,
23202                    .alen      =3D 16,
23203                    .result   =3D "\x2E\x9A\xCA\x6B\xDA\x54\xFC\x6F"
23204                                      "\x12\x50\xE8\xDE\x81\x3C\x63\x0=
8"
23205                                      "\x1A\x22\xBA\x75\xEE\xD4\xD5\xB=
5"
23206                                      "\x27\x50\x01\xAC\x03\x33\x39\xF=
B",
23207                    .rlen       =3D 32,


I have a test program using open ssl API (-l crypto), and run on Ubuntu Lin=
ux PC,   I  get the following  test result:

2e 9a ca 6b da 54 fc 6f 12 50 e8 de 81 3c 63 08
fb 64 91 b4 dd dc bf 5d fd 67 e3 a2 f8 7c 0e 6c
              The first part of encrypted text is correct. But MAC is not t=
he same.

My program is as the following:

void ccmTest()
{
    /* Initialization */
    EVP_CIPHER_CTX ctx;
    EVP_CIPHER_CTX *cryptCtx =3D &ctx;
    EVP_CIPHER_CTX_init(cryptCtx);
    int i;

   unsigned char P[16] =3D {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int Psize =3D sizeof(P);
    unsigned char K[16] =3D {0};
    unsigned char N[11] =3D {0};
    unsigned char A[16] =3D {0};
    unsigned char CT[128];

    int Nsize =3D 11;
    int Tsize =3D 16;

    // Initialize the context with the alg only
    EVP_EncryptInit(cryptCtx, EVP_aes_128_ccm(), 0, 0);

    // Set nonce and tag sizes
    EVP_CIPHER_CTX_ctrl(cryptCtx, EVP_CTRL_CCM_SET_IVLEN, Nsize, 0);
    EVP_CIPHER_CTX_ctrl(cryptCtx, EVP_CTRL_CCM_SET_TAG, Tsize, 0);

    // Finally set the key and the nonce
    EVP_EncryptInit(cryptCtx, 0, K, N);

    // Tell the alg we will encrypt Psize bytes
    int outl =3D 0;
    EVP_EncryptUpdate(cryptCtx, 0, &outl, 0, sizeof(P));
   // Add the AAD
    EVP_EncryptUpdate(cryptCtx, 0, &outl, A, sizeof(A));
   // Now we encrypt the data in P, placing the output in CT
    EVP_EncryptUpdate(cryptCtx, CT, &outl, P, Psize);
    EVP_EncryptFinal(cryptCtx, &CT[outl], &outl);
    // Append the tag to the end of the encrypted output
    EVP_CIPHER_CTX_ctrl(cryptCtx, EVP_CTRL_CCM_GET_TAG, Tsize, &CT[Psize]);
    hexdump(CT, Tsize+Psize);
}


I run "insmod tcrypt.ko mode=3D45"  rfc4309 test with Qualcomm crypto hardw=
are on Linux4.4. The test fails. The generated output is the same as my ope=
nSSL test application in 1. =20

My test application runs on Ubuntu with linux 3.10 rfc4309 test vector, and=
 generated MAC as expected from test vectors.  Qualcomm crypto hardware run=
s "insmod tcrypt.ko mode=3D45" successfully with linux 3.10.

I am suspicious about the test vectors of 4.4. Can someone verify the Linux=
 4.4 rfc4309 test vectors with his/her openSSL application on PC?

Chemin
