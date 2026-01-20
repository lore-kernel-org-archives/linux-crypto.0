Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05EE44A715
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921468; cv=none; b=VAlOhkz6DF3wCfWQmPlTKzYxu65h9KmveQ0kRvJLbm2cfobNb34qJ8irNT1SfETQ63mjbRrzS2awYi8EEJPgXsRTfIiMZWg2eQDqt8HY1GiLL7VXMPb+JO/GLNr0FjlMxK8svCKXhHKsECPUDv2atcyMODh0xDPvrALWP42YEIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921468; c=relaxed/simple;
	bh=tYMIXoNs7RLmE9EbJZd1a3k4/fGnkHUee6sJ+AGZnv8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DO0iGKdTwG6fGSg3rF97EEcPeOs9csfNbUSjmOnAh8VMjdqpi8SsFJwhDVzT19i7G9EHAOFxtkZ2hkw0OMtSJdjH7UX6ek6FB5h9fnuSV717cL4Wi+r+v07XtbtQOD04fN08VyQ61sD/1cNGmII/YSCFPvXZVnuAUFV74E0NjTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aeKb9eXx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aeKb9eXx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768921465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnr591BgrQ+PqF+y6uG/C+LNFozW+JGmENxSfQ88pUs=;
	b=aeKb9eXxh6Lpf+3sdYJ3FTMOGxbpYXBaq4rzlzbUBzEajZ9CZOctVT1Fw3El7k+Tj1UM/Q
	qkBNB3EXT+kkAxl48F4IBsX7jzCH+VypKcuLi5SYD3eQNWSST62qFc6E7oeMdx6i0rwjxb
	QfWhKHQp1qhtWY83bDysXYhoRD9WUfA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-ScQzAoHyNaayIPMq8OyJhw-1; Tue,
 20 Jan 2026 10:04:22 -0500
X-MC-Unique: ScQzAoHyNaayIPMq8OyJhw-1
X-Mimecast-MFC-AGG-ID: ScQzAoHyNaayIPMq8OyJhw_1768921459
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37170195606D;
	Tue, 20 Jan 2026 15:04:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 146BD19560A2;
	Tue, 20 Jan 2026 15:04:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260119185125.GA11957@sol>
References: <20260119185125.GA11957@sol> <1010414.1768841311@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>,
    Stephan Mueller <smueller@chronox.de>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Herbert Xu <herbert@gondor.apana.org.au>
Subject: Python script to generate X509/CMS from NIST testcases
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1176795.1768921455.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Jan 2026 15:04:15 +0000
Message-ID: <1176796.1768921455@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Eric, Stephan,

In case it turns out to be useful to you as a template, here's a script th=
at I
wrote to package NIST ML-DSA testcases from JSON files into rudimentary X.=
509,
message and CMS signature files and also to produce a C file that contains
those blobs packaged into u8 arrays with a table listing them all.

It also tries to verify each testcase with "openssl smime" - except that t=
hat
doesn't work too will for ML-DSA (it did work for RSASSA-PSS, but that's
another script).

David
---
#!/usr/bin/python3
#
# Generate X.509 certificates and CMS messages from NIST ML-DSA SigVer tes=
t
# vectors (e.g. prompt.json).

import os
import sys
import datetime
import subprocess
import asn1tools
import json

if len(sys.argv) < 3:
    print("Format x509_gen.py <prompt.json> <expectedResults.json>", file=3D=
sys.stderr)
    exit(2)

OID_rsaEncryption               =3D "1.2.840.113549.1.1.1"
OID_sha1WithRSAEncryption       =3D "1.2.840.113549.1.1.5"
OID_id_mgf1                     =3D "1.2.840.113549.1.1.8"
OID_id_rsassa_pss               =3D "1.2.840.113549.1.1.10"
OID_sha256WithRSAEncryption     =3D "1.2.840.113549.1.1.11"
OID_sha384WithRSAEncryption     =3D "1.2.840.113549.1.1.12"
OID_sha512WithRSAEncryption     =3D "1.2.840.113549.1.1.13"
OID_sha224WithRSAEncryption     =3D "1.2.840.113549.1.1.14"
OID_sha1                        =3D "1.3.14.3.2.26"
OID_sha256                      =3D "2.16.840.1.101.3.4.2.1"
OID_sha384                      =3D "2.16.840.1.101.3.4.2.2"
OID_sha512                      =3D "2.16.840.1.101.3.4.2.3"
OID_sha224                      =3D "2.16.840.1.101.3.4.2.4"
OID_commonName                  =3D "2.5.4.3"
OID_subjectKeyIdentifier        =3D "2.5.29.14"
OID_keyUsage                    =3D "2.5.29.15"
OID_basicConstraints            =3D "2.5.29.19"
OID_data                        =3D "1.2.840.113549.1.7.1"
OID_signed_data                 =3D "1.2.840.113549.1.7.2"
OID_id_ml_dsa_44                =3D "2.16.840.1.101.3.4.3.17"
OID_id_ml_dsa_65                =3D "2.16.840.1.101.3.4.3.18"
OID_id_ml_dsa_87                =3D "2.16.840.1.101.3.4.3.19"

##########################################################################=
#####
#
# ASN.1 definitions
#
##########################################################################=
#####
RSA =3D asn1tools.compile_string("""
Rsa DEFINITIONS ::=3D BEGIN
RsaPubKey ::=3D SEQUENCE {
	n INTEGER,
	e INTEGER
}
RSASSA-PSS-params ::=3D SEQUENCE {
	hashAlgorithm      [0] HashAlgorithm,
	maskGenAlgorithm   [1] MaskGenAlgorithm,
	saltLength         [2] INTEGER,
	trailerField       [3] TrailerField OPTIONAL
}
HashAlgorithm ::=3D AlgorithmIdentifier
MaskGenAlgorithm ::=3D AlgorithmIdentifier
TrailerField ::=3D INTEGER
AlgorithmIdentifier ::=3D SEQUENCE {
	algorithm	OBJECT IDENTIFIER,
	parameters	ANY OPTIONAL
}
END""", 'der')

#-------------------------------------------------------------------------=
-----
# X.509
#
X509 =3D asn1tools.compile_string("""
X509 DEFINITIONS ::=3D BEGIN
Certificate ::=3D SEQUENCE {
	tbsCertificate		TBSCertificate,
	signatureAlgorithm	AlgorithmIdentifier,
	signature		BIT STRING
	}
TBSCertificate ::=3D SEQUENCE {
	version           [ 0 ]	Version,
	serialNumber		CertificateSerialNumber,
	signature		AlgorithmIdentifier,
	issuer			Name,
	validity		Validity,
	subject			Name,
	subjectPublicKeyInfo	SubjectPublicKeyInfo,
	issuerUniqueID    [ 1 ]	IMPLICIT UniqueIdentifier OPTIONAL,
	subjectUniqueID   [ 2 ]	IMPLICIT UniqueIdentifier OPTIONAL,
	extensions        [ 3 ]	Extensions OPTIONAL
	}
Version ::=3D INTEGER
CertificateSerialNumber ::=3D INTEGER
AlgorithmIdentifier ::=3D SEQUENCE {
	algorithm		OBJECT IDENTIFIER,
	parameters		ANY OPTIONAL
}
Name ::=3D SEQUENCE OF RelativeDistinguishedName
RelativeDistinguishedName ::=3D SET OF AttributeValueAssertion
AttributeValueAssertion ::=3D SEQUENCE {
	attributeType		OBJECT IDENTIFIER,
	attributeValue		UTF8String -- Really ANY
	}
Validity ::=3D SEQUENCE {
	notBefore		Time,
	notAfter		Time
	}
Time ::=3D CHOICE {
	utcTime			UTCTime,
	generalTime		GeneralizedTime
	}
SubjectPublicKeyInfo ::=3D SEQUENCE {
	algorithm		AlgorithmIdentifier,
	subjectPublicKey	BIT STRING
	}
UniqueIdentifier ::=3D BIT STRING
Extensions ::=3D SEQUENCE OF Extension
Extension ::=3D SEQUENCE {
	extnid			OBJECT IDENTIFIER,
	critical		BOOLEAN,
	extnValue		OCTET STRING
	}
END""", 'der')

#-------------------------------------------------------------------------=
-----
# PKCS#7
#
PKCS7 =3D asn1tools.compile_string("""
PKCS7 DEFINITIONS ::=3D BEGIN
PKCS7ContentInfo ::=3D SEQUENCE {
	contentType	ContentType,
	content		[0] EXPLICIT SignedData OPTIONAL
}
ContentType ::=3D OBJECT IDENTIFIER
SignedData ::=3D SEQUENCE {
	version			INTEGER,
	digestAlgorithms	DigestAlgorithmIdentifiers,
	contentInfo		ContentInfo,
	certificates		CHOICE {
		certSet		[0] IMPLICIT ExtendedCertificatesAndCertificates,
		certSequence	[2] IMPLICIT Certificates
	} OPTIONAL,
	crls CHOICE {
		crlSet		[1] IMPLICIT CertificateRevocationLists,
		crlSequence	[3] IMPLICIT CRLSequence
	} OPTIONAL,
	signerInfos		SignerInfos
}
ContentInfo ::=3D SEQUENCE {
	contentType	ContentType,
	content		[0] EXPLICIT Data OPTIONAL
}
Data ::=3D ANY
DigestAlgorithmIdentifiers ::=3D CHOICE {
	daSet			SET OF DigestAlgorithmIdentifier,
	daSequence		SEQUENCE OF DigestAlgorithmIdentifier
}
DigestAlgorithmIdentifier ::=3D SEQUENCE {
	algorithm   OBJECT IDENTIFIER,
	parameters  ANY OPTIONAL
}
ExtendedCertificatesAndCertificates ::=3D SET OF ExtendedCertificateOrCert=
ificate
ExtendedCertificateOrCertificate ::=3D CHOICE {
  certificate		Certificate,
  extendedCertificate	[0] IMPLICIT ExtendedCertificate
}
ExtendedCertificate ::=3D Certificate
Certificates ::=3D SEQUENCE OF Certificate
CertificateRevocationLists ::=3D SET OF CertificateList
CertificateList ::=3D SEQUENCE OF Certificate
CRLSequence ::=3D SEQUENCE OF CertificateList
Certificate ::=3D BOOLEAN -- This really needs to be ANY, but asn1tools ex=
plodes
SignerInfos ::=3D CHOICE {
	siSet		SET OF SignerInfo,
	siSequence	SEQUENCE OF SignerInfo
}
SignerInfo ::=3D SEQUENCE {
	version			INTEGER,
	sid			SignerIdentifier,
	digestAlgorithm		DigestAlgorithmIdentifier,
	authenticatedAttributes	CHOICE {
		aaSet		[0] IMPLICIT SetOfAuthenticatedAttribute,
		aaSequence	[2] EXPLICIT SEQUENCE OF AuthenticatedAttribute
	} OPTIONAL,
	digestEncryptionAlgorithm
				DigestEncryptionAlgorithmIdentifier,
	encryptedDigest		EncryptedDigest,
	unauthenticatedAttributes CHOICE {
		uaSet		[1] IMPLICIT SET OF UnauthenticatedAttribute,
		uaSequence	[3] IMPLICIT SEQUENCE OF UnauthenticatedAttribute
	} OPTIONAL
}
SignerIdentifier ::=3D CHOICE {
	issuerAndSerialNumber IssuerAndSerialNumber,
        subjectKeyIdentifier [0] IMPLICIT SubjectKeyIdentifier
}
IssuerAndSerialNumber ::=3D SEQUENCE {
	issuer			Name,
	serialNumber		CertificateSerialNumber
}
CertificateSerialNumber ::=3D INTEGER
SubjectKeyIdentifier ::=3D OCTET STRING
SetOfAuthenticatedAttribute ::=3D SET OF AuthenticatedAttribute
AuthenticatedAttribute ::=3D SEQUENCE {
	type			OBJECT IDENTIFIER,
	values			SET OF ANY
}
UnauthenticatedAttribute ::=3D SEQUENCE {
	type			OBJECT IDENTIFIER,
	values			SET OF ANY
}
DigestEncryptionAlgorithmIdentifier ::=3D SEQUENCE {
	algorithm		OBJECT IDENTIFIER,
	parameters		ANY OPTIONAL
}
EncryptedDigest ::=3D OCTET STRING
Name ::=3D SEQUENCE OF RelativeDistinguishedName
RelativeDistinguishedName ::=3D SET OF AttributeValueAssertion
AttributeValueAssertion ::=3D SEQUENCE {
	attributeType		OBJECT IDENTIFIER,
	attributeValue		UTF8String -- Really ANY
}
END""", 'der')

##########################################################################=
#####
#
# Write a C data array from a bytestring.
#
##########################################################################=
#####
def write_c_hexarray(cfile, name, data):
    cfile.write("static const u8 " + name + "[] __initconst =3D {\n")
    need_close =3D False
    for i in range(0, len(data)):
        if not need_close:
            cfile.write("\t\"")
            need_close =3D True
        cfile.write("\\x{:02x}".format(data[i]))
        if i & 0xf =3D=3D 0xf:
            cfile.write("\"\n")
            need_close =3D False
    if need_close:
            cfile.write("\"\n")
    cfile.write("};\n")

vector_table =3D list()

def write_c(cfile, name, x509, data, pkcs7, result):
    write_c_hexarray(cfile, name + "_key", x509)
    write_c_hexarray(cfile, name + "_data", data)
    write_c_hexarray(cfile, name + "_sig", pkcs7)
    cfile.write("\n")

    vector_table.append("\t{\n");
    vector_table.append("\t\t.name\t\t=3D \"" + name + "\",\n");
    vector_table.append("\t\t.key\t\t=3D "  + name + "_key,\n");
    vector_table.append("\t\t.data\t\t=3D " + name + "_data,\n");
    vector_table.append("\t\t.sig\t\t=3D "  + name + "_sig,\n");
    vector_table.append("\t\t.key_len\t=3D sizeof("  + name + "_key) - 1,\=
n");
    vector_table.append("\t\t.data_len\t=3D sizeof("  + name + "_data) - 1=
,\n");
    vector_table.append("\t\t.sig_len\t=3D sizeof("  + name + "_sig) - 1,\=
n");
    vector_table.append("\t\t.pass\t\t=3D " + result + ",\n");
    vector_table.append("\t},\n");

def write_c_table(cfile, basename):
    cfile.write("const struct nist_test_vector " + basename + "[] __initco=
nst =3D {\n")
    for i in vector_table:
        cfile.write(i)
    cfile.write("};\n")


##########################################################################=
#####
#
# Create an X.509 certificate to hold an RSA public key and create a detac=
hed
# PKCS#7 message to carry a signature created with it.
#
##########################################################################=
#####
def create_rsa_key(n, e):
    """Create an RSA public key"""
    pubkey =3D RSA.encode("RsaPubKey", {
        'n' : rsa_n,
        'e' : rsa_e
        })

def create_rsassa_params(salt_len, digest_alg):
    """Create the parameters for RSASSA-PSS"""
    mgf1_params =3D RSA.encode("AlgorithmIdentifier", {
        'algorithm'         : digest_alg,
        'parameters'        : None
    })

    sig_params =3D RSA.encode("RSASSA-PSS-params", {
            'hashAlgorithm'         : {
                'algorithm'         : digest_alg,
                'parameters'        : None
            },
            'maskGenAlgorithm'      : {
                'algorithm'         : OID_id_mgf1,
                'parameters'        : mgf1_params
                },
            'saltLength'            : salt_len,
        })

def create_cert_and_sig(basename, count, pubkey, signature, sig_params, co=
ntent,
                        digest_alg, sig_alg, result, cfile):
    serial =3D 0x1234000 + count

    # Create an X.509 certificate
    x509 =3D X509.encode("Certificate", {
        'tbsCertificate' : {
            'version'           : 2,
            'serialNumber'      : serial,
            'signature' : {
                'algorithm'         : sig_alg,
                'parameters'        : sig_params
            },
            'issuer' : [
                [
                    {
                        'attributeType' : OID_commonName,
                        'attributeValue' : "Fred"
                    }
                ]
            ],
            'validity' : {
                'notBefore' : ('utcTime',     datetime.datetime(2026, 1, 1=
)),
                'notAfter'  : ('generalTime', datetime.datetime(2199, 1, 1=
)),
            },
            'subject' : [
                [
                    {
                        'attributeType' : OID_commonName,
                        'attributeValue' : basename
                    }
                ]
            ],
            'subjectPublicKeyInfo' : {
                'algorithm' : {
                    'algorithm'         : sig_alg,
                    'parameters'        : None
                },
                'subjectPublicKey' : (pubkey, len(pubkey)*8)
            },
            'extensions' : [
                {
                    'extnid'	: OID_basicConstraints,
                    'critical'	: True,
                    'extnValue'	: b'\x30\x00'
                }, {
                    'extnid'	: OID_keyUsage,
                    'critical'	: False,
                    'extnValue'	: b'\x03\x02\x07\x80'
                }, {
                    'extnid'	: OID_subjectKeyIdentifier,
                    'critical'	: False,
                    'extnValue'	: bytes.fromhex("04142B73932CF06C341AA72CC=
EA4E0AC35A96CCC{:04x}".format(count)),
                },
            ]
        },
        'signatureAlgorithm' :  {
            'algorithm'         : sig_alg,
            'parameters'        : sig_params
        },
        'signature' : (signature, len(signature)*8)
    })

    # Create a detached PKCS#7 message to use as a signature carrier
    pkcs7 =3D PKCS7.encode("PKCS7ContentInfo", {
        'contentType'               : OID_signed_data,
        'content' : {
            'version'		: 1,
            'digestAlgorithms' : ( 'daSet', [
                {
                    'algorithm'         : digest_alg,
                    'parameters'        : None
                }
            ]),
            'contentInfo' : {
                'contentType'               : OID_data
            },
            'signerInfos' : ('siSet', [
                {
                    'version'		: 1,
                    'sid' : (
                        'issuerAndSerialNumber', {
                            'issuer'		: [
                                [
                                    {
                                        'attributeType' : OID_commonName,
                                        'attributeValue' : "Fred"
                                    }
                                ]
                            ],
                            'serialNumber' : serial
                        }
                    ),
                    'digestAlgorithm' : {
                        'algorithm'         : digest_alg,
                    },
                    'digestEncryptionAlgorithm' : {
                        'algorithm'         : sig_alg,
                        'parameters'        : sig_params
                    },
                    'encryptedDigest'	: signature,
                }
            ])
        }
    })

    out =3D open(basename + ".x509", "wb")
    out.write(x509)
    out.close()

    out =3D open(basename + ".p7s", "wb")
    out.write(pkcs7)
    out.close()

    out =3D open(basename + ".data", "wb")
    out.write(content)
    out.close()

    write_c(cfile, basename, x509, content, pkcs7, result)

##########################################################################=
#####
#
# Parse FIPS JSON vector file
#
##########################################################################=
#####

vecfilename =3D sys.argv[1]
vecf =3D open(vecfilename, "r")
testdata =3D json.load(vecf);
vecf.close()

expfilename =3D sys.argv[2]
expf =3D open(expfilename, "r")
expected =3D json.load(expf);
expf.close()

cfile =3D open("nist_testdata.c", "w")

def badfile(msg):
    print(vecfilename + ": " + msg, file=3Dsys.stderr);
    exit(3)
def skipg(tgid, msg):
    print("skipping tgId=3D" + str(tgid) + ": " + msg, file=3Dsys.stderr)
def skipc(tcid, msg):
    print("skipping tcId=3D" + str(tcid) + ": " + msg, file=3Dsys.stderr)

if testdata["mode"] !=3D "sigVer":
    badfile("Only sigVer files supported")

if testdata["algorithm"] !=3D "ML-DSA":
    badfile("Unsupported algo " + testdata["algorithm"])

if expected["algorithm"] !=3D testdata["algorithm"] or \
   expected["revision"] !=3D testdata["revision"] or \
   expected["vsId"] !=3D testdata["vsId"] or \
   expected["mode"] !=3D testdata["mode"]:
    badfile("Doesn't match expected data file")

rname =3D "nist-"
rname +=3D testdata["algorithm"].replace("-", "").lower() + "-"
rname +=3D testdata["revision"].lower()
rname =3D rname.replace("-", "_")
count =3D 0

results =3D dict()
for tgroup in expected["testGroups"]:
    for test in tgroup["tests"]:
        tcid =3D test["tcId"]
        results[tcid] =3D test["testPassed"]

for tgroup in testdata["testGroups"]:
    tgid =3D tgroup["tgId"]

    if tgroup["testType"] !=3D "AFT":
        skipg(tgid, "Not an Algorithm Functional Test")
        continue

    if tgroup["signatureInterface"] =3D=3D "external":
        if tgroup["preHash"] =3D=3D "preHash":
            skipg(tgid, "Pre-hashing required")
            continue
        if tgroup["preHash"] !=3D "pure":
            skipg(tgid, "Not pure")
            continue
    else:
        if tgroup["externalMu"]:
            skipg(tgid, "External-mu required")
            continue
        #json.dump(tgroup, sys.stdout)
        #skipg(tgid, "Internal")
        #continue

    if tgroup["parameterSet"] =3D=3D "ML-DSA-44":
        sig_algo =3D OID_id_ml_dsa_44
        hash_algo =3D None
    elif tgroup["parameterSet"] =3D=3D "ML-DSA-65":
        sig_algo =3D OID_id_ml_dsa_65
        hash_algo =3D None
    elif tgroup["parameterSet"] =3D=3D "ML-DSA-87":
        sig_algo =3D OID_id_ml_dsa_87
        hash_algo =3D None
    else:
        badfile("Unsupported algo " + testdata["algorithm"])

    for test in tgroup["tests"]:
        tcid =3D test["tcId"]
        pubkey =3D bytes.fromhex(test["pk"])
        message =3D bytes.fromhex(test["message"])
        signature =3D bytes.fromhex(test["signature"])
        sig_params =3D None

        try:
            if test["hashAlg"] =3D=3D "SHA1":
                digest_algo =3D OID_sha1
            elif test["hashAlg"] =3D=3D "SHA224":
                digest_algo =3D OID_sha224
            elif test["hashAlg"] =3D=3D "SHA256":
                digest_algo =3D OID_sha256
            elif test["hashAlg"] =3D=3D "SHA384":
                digest_algo =3D OID_sha384
            elif test["hashAlg"] =3D=3D "SHA512":
                digest_algo =3D OID_sha512
            else:
                skipc("Unknown algo:", test["hashAlg"])
                continue
        except KeyError:
            if testdata["algorithm"] !=3D "ML-DSA":
                skipc("No hash algo")
                continue
            digest_algo =3D OID_sha512

        result =3D results[tcid]
        if result:
            result_val =3D "true"
        else:
            result_val =3D "false"

        name =3D rname + "_" + str(tcid);
        create_cert_and_sig(name, tcid,
                            pubkey, signature, sig_params, message,
                            digest_algo,
                            sig_algo,
                            result_val,
                            cfile)
        count +=3D 1

        os.environ["LD_LIBRARY_PATH"] =3D "/data/openssl/build/"
        status =3D subprocess.run([ "/data/openssl/build/apps/openssl",
                                  "smime", "-verify", "-binary",
                                  "-inform", "DER", "-in", name + ".p7s",
                                  "-content", name + ".data",
                                  "-certfile", name + ".x509",
                                  "-nointern",
                                  "-noverify",
                                  "-out", "/dev/null"
                                 ],
                                capture_output =3D True)

        if status.returncode !=3D 0:
            print("tcId=3D" + str(tcid) +
                  ": Unexpected failure", name, status.returncode)
            #sys.stderr.buffer.write(status.stderr)
            #exit(4)
        else:
            print("tcId=3D" + str(tcid) + ": Success", name)

write_c_table(cfile, rname)

print("Wrote", count, "test vectors");

