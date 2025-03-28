Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE18D26AC3;
	Fri, 28 Mar 2025 03:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743132405; cv=none; b=mzuU/Z0gEyhodJZYQFCWWOzT1HwlvZnzsEsd/D3gJsc9nS2IkrIMuoDVvOsqHeHYcIDH0eHhTt/geJz36uD3nUIsE5CV+oi4dmSj+Nch7a/B8xMhfm5C0tZkA/OmxO42U85t0gttNJNHJusbFGRzV/K86ff77PHw8pa/YlRhkjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743132405; c=relaxed/simple;
	bh=+apTMILyuzoKGjYoNsju5JB1rSx0wdhfEltS4X8Zfm4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=S4S7hCk0COjyBpTQQxd1SU64XV8Dsl3xHPrFNzHJ3g6H0mK0zocR7fhDPR914vQCRA7WpcQh+mrXVAWDEBFRvnKcl7v3n0rZjiGojDVHdepdZpC2t81ay5S2dnEw8xXRtNN7mEkEbOUyzqF5/oZywHtrLK6GedpbOJcMhl03feQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from jtjnmail201620.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202503281126270447;
        Fri, 28 Mar 2025 11:26:27 +0800
Received: from jtjnmail201622.home.langchao.com (10.100.2.22) by
 jtjnmail201620.home.langchao.com (10.100.2.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Mar 2025 11:26:27 +0800
Received: from jtjnmail201622.home.langchao.com ([fe80::15c3:8d74:3aa6:25f6])
 by jtjnmail201622.home.langchao.com ([fe80::15c3:8d74:3aa6:25f6%7]) with mapi
 id 15.01.2507.039; Fri, 28 Mar 2025 11:26:27 +0800
From: =?utf-8?B?Qm8gTGl1ICjliJjms6IpLea1qua9ruS/oeaBrw==?=
	<liubo03@inspur.com>
To: "kristen.c.accardi@intel.com" <kristen.c.accardi@intel.com>,
	"vinicius.gomes@intel.com" <vinicius.gomes@intel.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?RG91IHpoaSBjaG9uZyBEb3UgKOeqpuW/l+WGsik=?= <douzhichong@inspur.com>
Subject: Intel IAA issue consultation
Thread-Topic: Intel IAA issue consultation
Thread-Index: AdufkEvJfAQaVtDyQmuUDCsR4b4QKA==
Date: Fri, 28 Mar 2025 03:26:27 +0000
Message-ID: <7f9bf073f04d4ba6b0d98f6189d951bc@inspur.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0009_01DB9FD3.F1F08830"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
tUid: 20253281126274143ae6e0c39763f2d3a34275742cb0e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

------=_NextPart_000_0009_01DB9FD3.F1F08830
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi Kristen:

We recently encountered issues when using Intel IAA (In-Memory Analytics =
Accelerator) for data decompression in the Linux kernel. Specifically, =
while using the iaa_crypto driver, decompression fails when processing =
large datasets composed of non-contiguous memory pages. Initially, we =
attempted to address this by using scatterlists (SGLs), but =
decompression still failed. After analyzing the iaa_crypto driver code, =
we discovered that =E2=80=8Bnon-contiguous pages require enabling IOMMU =
to map them into a single virtual contiguous memory block for the =
device. However, while this approach worked for small numbers of =
non-contiguous pages, it failed for larger quantities due to IOMMU =
limitations in mapping fragmented pages into a unified virtual address =
space.

We would like to consult with you

Is it possible to use iaa_crypto for decompression with =
=E2=80=8Bnumerous non-contiguous pages?
If yes, what modifications are required to resolve the IOMMU mapping =
constraints?

Thanks,
Bo Liu.

------=_NextPart_000_0009_01DB9FD3.F1F08830
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
9w0DAgICAIAwDgYIKoZIhvcNAwQCAgCAMAcGBSsOAwIHMAoGCCqGSIb3DQMHMB0GA1UdDgQWBBTk
Hdp/y3+DuDJ13Q1YzgU9iV7NdzAfBgNVHSMEGDAWgBReWQOmtExYYJFO9h61pTmmMsE1ajCCAQ8G
A1UdHwSCAQYwggECMIH/oIH8oIH5hoG6bGRhcDovLy9DTj1JTlNQVVItQ0EsQ049SlRDQTIwMTIs
Q049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3Vy
YXRpb24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlz
dD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hjpodHRwOi8vSlRDQTIwMTIu
aG9tZS5sYW5nY2hhby5jb20vQ2VydEVucm9sbC9JTlNQVVItQ0EuY3JsMIIBKQYIKwYBBQUHAQEE
ggEbMIIBFzCBsQYIKwYBBQUHMAKGgaRsZGFwOi8vL0NOPUlOU1BVUi1DQSxDTj1BSUEsQ049UHVi
bGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1ob21l
LERDPWxhbmdjaGFvLERDPWNvbT9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlm
aWNhdGlvbkF1dGhvcml0eTBhBggrBgEFBQcwAoZVaHR0cDovL0pUQ0EyMDEyLmhvbWUubGFuZ2No
YW8uY29tL0NlcnRFbnJvbGwvSlRDQTIwMTIuaG9tZS5sYW5nY2hhby5jb21fSU5TUFVSLUNBLmNy
dDBBBgNVHREEOjA4oCIGCisGAQQBgjcUAgOgFAwSbGl1Ym8wM0BpbnNwdXIuY29tgRJsaXVibzAz
QGluc3B1ci5jb20wDQYJKoZIhvcNAQELBQADggEBAA+BaY3B3qXmvZq7g7tZLzq2VQjU//XHTmyl
58GLDWdVHsuX3lrAGwEfLVnUodpvthjtb7T7xEUzJh4F62zLFSm8HOBPH1B+6SFQKChHZeM0pauv
Xr1krRtVv82RgLsU26XrXFUPN+NcPwt7vOw1zHOiDic4anL3A9gsuDljAi2l+CA5RY05yL+8oras
EAhOYL6+ks9aB8QiCxbZzShkDTMkrh0N1DjoBLaibtnlI/fxOUYM6vgdiI+FC02G41B364ZAc1ma
bSFvGIP6cIdr/olprPQOj9cq6zMi05qUBUj22hDvhcY0TlT4fEJSrvblp/LG6qTtVI3ilUAxhe8i
9cIxggOTMIIDjwIBATBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZFghs
YW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAA0dHV
TGwIT1/wiwAAAADR0TAJBgUrDgMCGgUAoIIB+DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNTAzMjgwMzI0MThaMCMGCSqGSIb3DQEJBDEWBBRwkzhKdOPzrJindkLj
8x1y0MMnlDB/BgkrBgEEAYI3EAQxcjBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJ
k/IsZAEZFghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1D
QQITfgAA0dHVTGwIT1/wiwAAAADR0TCBgQYLKoZIhvcNAQkQAgsxcqBwMFkxEzARBgoJkiaJk/Is
ZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUx
EjAQBgNVBAMTCUlOU1BVUi1DQQITfgAA0dHVTGwIT1/wiwAAAADR0TCBkwYJKoZIhvcNAQkPMYGF
MIGCMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMA4G
CCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCGjALBglghkgBZQMEAgMwCwYJYIZI
AWUDBAICMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC9Nf1rsx+tjr5Pj4kAe6Y8hg1c
MTKwvs1BbJEGDoSaUAa7+0tDHFZCjlrR3LRGfJY8OFbLBUZGnPeSkWv8kvPIR7V3iqze5q0RuLrW
xiSF8/ahNRSIgJd/PmQDV1Bu/12pCN9KXLlnkh4YgxuSUKYdGn4kfvMuM1ndcjs4snYtIL58zsAR
aKRf5M4/hQUqANqmAnQBIEO3D1Y+JdADbDFz5pBWNP5Wi0WBLmTJqyys/Bz2+7rv0gWb2cJQWwhF
rUISR7Vi/XQIy/XZB2adgm0EpZkSTsmXs4EUc4B6826I+q8CxzQRQ7re+PRdPces2T6lSeVuNANV
Ay6dcjS85G3SAAAAAAAA

------=_NextPart_000_0009_01DB9FD3.F1F08830--
